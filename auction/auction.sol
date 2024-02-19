// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CreateAuction{
    Auction[] public auctions;
    function createAuction()public{
        Auction newAuction=new Auction(msg.sender);
        auctions.push(newAuction);
    }
}
contract Auction{
    address payable  public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipHash;
    enum State{Started,Runing,Ended,Canceled}
    State public auctionstate;

    uint public highestBindingBid;
    address payable public highestBidder;
    mapping (address=>uint)public bids;
    uint bidIncrement;

    constructor(address eoa){
        owner=payable (eoa);
        ipHash="";
        auctionstate=State.Started;
        startBlock=block.number;
        // endBlock=startBlock+40320;
        endBlock=startBlock+3;//test
        // bidIncrement=100 wei;
        bidIncrement=1 ether;
    }
    modifier onlyOwner(){
        require(msg.sender==owner,"only owner have authorition");
        _;
    }
    modifier notOwner(){
        require(msg.sender!=owner,"owner is not authorition");
        _;
    }
    modifier afterStart(){
        require(block.number>=startBlock);
        _;
    }
    modifier beforeEnd(){
        require(block.number<endBlock);
        _;
    }
    function cancelAution()public onlyOwner{
        auctionstate=State.Canceled;
    }
    function min(uint a,uint b)pure internal  returns(uint){
        if (a>b){
            return b;
        }else {
            return a;
        }
    }

    function pricBid()public payable notOwner afterStart beforeEnd{
        require(auctionstate==State.Runing,"state is not runing");
        require(msg.value>=100,"your money not bigger 100 wei");
        uint currentBid=bids[msg.sender]+msg.value;
        require(currentBid>highestBindingBid,"your money not bigger max price");
        bids[msg.sender]=currentBid;
        if (currentBid<=bids[highestBidder]){
            highestBindingBid=min(currentBid+bidIncrement,bids[highestBidder]);
        }else {
            highestBindingBid=min(currentBid,bids[highestBidder]+bidIncrement);
            highestBidder=payable(msg.sender);
        }
    }

    function finalizeAuction()public{
        require(auctionstate==State.Canceled||block.number==endBlock);
        require(msg.sender==owner||bids[msg.sender]>0);
        address payable recipient;
        uint value;

        if (auctionstate==State.Canceled){
            recipient=payable(msg.sender);
            value=bids[msg.sender];
        }else {
            if (msg.sender==owner){
                recipient=owner;
                value=highestBindingBid;
            }else {
                if (msg.sender==highestBidder){
                    recipient=highestBidder;
                    value=bids[highestBidder]-highestBindingBid;
                }else {
                    recipient=payable(msg.sender);
                    value=bids[msg.sender];
                }
            }
        }
        bids[recipient]=0;
        recipient.transfer(value);
    }
}