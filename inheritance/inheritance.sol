// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


abstract  contract BaseContract{
    int public x;
    address public owner;
    constructor(){
        owner=msg.sender;
        x=5;
    }
    function setX(int _x)public virtual;
}

contract A is BaseContract {
    int public y;
    function setX(int _x)public override {
        x=_x;
    }
} 