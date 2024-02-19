//get funds from users
// Withdraw funds
// Set a mininum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./priceinfo.sol";
contract FundMe{
    using  priceInfo for uint256;
    uint256 constant MININUM=50*1e18;
    address[] public users;
    address public immutable i_owner;
    constructor(){
        i_owner=msg.sender;
    }
    mapping (address=>uint256) public addprce;
    function Fund()public payable {
       
        //want to  be able set a mininum  fund amount
        //1 how do we send eth to this contract
        require(msg.value.getConversionRate()>=MININUM,"Didn't  send enouth!");
        users.push(msg.sender);
        addprce[msg.sender]=msg.value;
    }
    
      
     function Withdraw()public onwerCheck {
        for (uint256 funderindex=0;funderindex<users.length;funderindex++){
            address adr=users[funderindex];
            addprce[adr]=0;
        }
        users=new address[](0);
        //tranfer
        // payable(msg.sender).transfer(address(this).balance);
        // //send
        // bool sendsuccess=payable(msg.sender).send(address(this).balance);
        // require(sendsuccess,"send failde");
        //call
        (bool callsuccess,)=payable(msg.sender).call{value:address(this).balance}("");
        require(callsuccess,"call failed");
     }
     modifier onwerCheck{
        require(msg.sender==i_owner,"sender is not owner");
        _;
     }
     receive() external payable {Fund(); }
     fallback() external payable { Fund(); }
}