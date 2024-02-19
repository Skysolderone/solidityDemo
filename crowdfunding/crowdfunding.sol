// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract CrowdFunding{
    mapping(address=>uint) public contributors;
    address public admin;
    uint public noOfContributors;
    uint public mininumContribution;
    uint public deadline;
    uint public goal;
    uint public raisedAmount;
    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voters;
    }
    mapping (uint=>Request)public requests;
    uint public numRequests;
    event CountributeEvent(address _adr,uint _value);
    event CreateRequestEvent(string _description,address  _recipient, uint _value);
    event MakePaymentEvent(address _recipient,uint _value );
    constructor(uint _goal,uint _deadline){
        goal=_goal;
        deadline=block.timestamp+_deadline;
        admin=msg.sender;
        mininumContribution=100 wei;

    }
    modifier  onlyAdmin(){
        require(msg.sender==admin,"only admin can call this function");
        _;
    }
    function countribute()public payable  {
        require(block.timestamp<deadline,"is finished");
        require(msg.value>=mininumContribution,"is not accetp this money");
        if (contributors[msg.sender]==0){
            noOfContributors++;
        }
        contributors[msg.sender]+=msg.value;
        raisedAmount+=msg.value;
        emit CountributeEvent(msg.sender, msg.value);
    }

    function getBalance()public view returns(uint){
        return address(this).balance;
    }
    //退还钱款
    function getRefund() public {
        require(block.timestamp>deadline&&raisedAmount<goal);
        require(contributors[msg.sender]>0);
        payable(msg.sender).transfer(contributors[msg.sender]);
        contributors[msg.sender]=0; 
    }

    function createRequest(string memory _description,address  payable _recipient,uint _value)public onlyAdmin{
        Request storage newRequest=requests[numRequests];
        numRequests++;
        newRequest.description=_description;
        newRequest.recipient=_recipient;
        newRequest.value=_value;
        newRequest.completed=false;
        newRequest.noOfVoters=0;
        emit CreateRequestEvent(_description, _recipient, _value);
    }
    //成员投票
    function voteRequest(uint _RequestNo)public {
        require(contributors[msg.sender]>0,"you must contribute this vote");
        Request storage thisRequest=requests[_RequestNo];
        require(thisRequest.voters[msg.sender]==false,"you alreaddy vote");
        thisRequest.voters[msg.sender]=true;
        thisRequest.noOfVoters++;
    }
    //是否通过
    function makePayment(uint _RequestNo)public {
        require(raisedAmount>=goal);
        Request storage thisRequest=requests[_RequestNo];
        require(thisRequest.completed==false,"vote is already completed");
        require(thisRequest.noOfVoters>noOfContributors/2,"voters not bigger %50");
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed=true;
        emit MakePaymentEvent(thisRequest.recipient, thisRequest.value);
    }
    receive() external payable {
        countribute();
     }
}