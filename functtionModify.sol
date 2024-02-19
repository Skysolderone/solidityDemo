// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract FunctionModify {
    address public owner;
    uint public x=10;
    bool public locked;
    constructor(){
        owner=msg.sender;
    }
    modifier onlyOwner(){
        require(msg.sender==owner,"Not owner");
        _;
    }
    modifier validAddress(address _addr){
        require(_addr!=address(0),"Not valid address'");
        _;
    }
    function changeowner(address _newOwner)public onlyOwner validAddress(_newOwner){
        owner=_newOwner;
    }
    modifier noReentrancy(){
        require(!locked,"No reentrany");
        locked=true;
        _;
        locked=false;
    }
    function decrement(uint i)public noReentrancy{
        x-=i;
        if (x>i){
            decrement(i-1);
        }
    }
}