// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//如果要实现某个代币  必须遵循以太坊特定的标准  及需要实现该标准定义的方法
interface ERC20Interface{
    function totalSupply()external view returns(uint);
    function balanceOf(address tokenOwner)external view returns(uint balance);
    function transfer(address to,uint tokens)external returns(bool success);

    function allowance(address tokenOwner,address spender)external  view returns (uint reminding);
    function approve(address spender,uint tokens)external returns(bool success);
    function transferFrom(address from,address to,uint tokens)external  returns(bool success);

    event Transfer(address indexed from,address indexed to,uint value);
    event Approval(address indexed tokenOwner,address indexed spender,uint tokens);
}

contract Cryptos is ERC20Interface{
    string public name="Cryptos";
    string public symbol="CRPT";
    uint public decimals=0;//精度
    uint public override  totalSupply;
    address public founder;
    mapping (address=>uint )public balances;
    mapping(address=>mapping(address =>uint))public allowcs;
    constructor(){
        founder=msg.sender;
        totalSupply=10000;
        balances[msg.sender]=totalSupply;
    }
        //返回用户持有的代币数
      function balanceOf(address tokenOwner)public override   view returns(uint balance){
        return balances[tokenOwner];
      }
      //向地址发送代币
    function transfer(address to,uint tokens)public override virtual  returns(bool success){
        require(balances[msg.sender]>=tokens,"not enouth coin");
        balances[to]+=tokens;
        balances[msg.sender]-=tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
    //该账户允许发送的代币
    function allowance(address tokenOwner,address spender)public override   view returns (uint reminding){
        return allowcs[tokenOwner][spender];
    }
    function approve(address spender,uint tokens)public override  returns(bool success){
        require(balances[msg.sender]>=tokens);
        require(balances[msg.sender]>0);
        allowcs[msg.sender][spender]=tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    //另一个用户给另外用户发送代币
    function transferFrom(address from,address to,uint tokens)public override  virtual  returns(bool success){
        require(allowcs[from][msg.sender]>=tokens);
        require(balances[from]>tokens);
        balances[from]-=tokens;
        allowcs[from][msg.sender]-=tokens;
        balances[to]+=tokens;
        emit Approval(from, to, tokens);
        return true;

    }


}

//ico
contract CryptoICO is Cryptos{
    address public admin;
    address payable public despoit;
    uint tokenprice=0.1 ether; //1eth=1000crpt 1crpt=0.001eth
    uint public hardCap=300 ether;
    uint public raiseamount;
    uint public saleStart=block.timestamp;
    uint public saleEnd=block.timestamp+604800;//1week
    uint public tokenTradeStart=saleEnd+604800;
    uint public maxInverstment=5 ether;
    uint public minInverstment=0.1 ether;
    enum State{beforeStart,runing,afterEnd,halted}
    State public icostate;
    event Invest(address adr,uint value,uint price);

    constructor(address payable _despoit) {
        despoit=_despoit;
        admin=msg.sender;
        icostate=State.beforeStart;
    }
    modifier  onlyOwner(){
        require(msg.sender==admin,"only admin can call this function");
        _;
    }
    function halt()public onlyOwner{
        icostate=State.halted;
    }
    function resume()public onlyOwner{
        icostate=State.runing;
    }
    function changeDespoitAddress(address payable newaddress)public onlyOwner{
        despoit=newaddress;
    }
    function getState()public view returns(State){
        if (icostate==State.halted){
            return State.halted;
        }else if(block.timestamp<saleEnd){
            return State.beforeStart;
        }else if(block.timestamp>saleStart&&block.timestamp<saleEnd){
            return State.runing;
        }else{
            return State.afterEnd;
        }
    }
    function invest()payable public returns(bool){
        icostate=getState();
        require(icostate==State.runing,"this contract is not runing");
        require(msg.value>=minInverstment&&msg.value<=maxInverstment);
        raiseamount+=msg.value;
        require(raiseamount<=hardCap);
        uint tokens=msg.value/tokenprice;
        balances[msg.sender]+=tokens;
        balances[founder]-=tokens;
        despoit.transfer(msg.value);
        emit Invest(msg.sender, msg.value,tokens);
        return true;
    }
    function transfer(address to,uint tokens)public override   returns(bool success){
        require(block.timestamp>tokenTradeStart);
        super.transfer(to, tokens);
        return true;
    }
    function transferFrom(address from,address to,uint tokens)public override    returns(bool success){
        require(block.timestamp>tokenTradeStart);
        super.transferFrom(from, to, tokens);
        return true;
    }
    function burn()public returns(bool){
        icostate=getState();
        require(icostate==State.afterEnd);
        balances[founder]=0;
        return true;
    }
    receive() external payable {invest(); }

}
