// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
//不变的变量

contract Immutable{
    address public immutable MY_ADDRESS;
    uint public immutable MY_INT;
    constructor(uint _myuint){
        MY_ADDRESS=msg.sender;
        MY_INT=_myuint;
    }
}