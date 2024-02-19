// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Gas {
    uint public i=0;
    function forever()public{
        while(true){
            i+=1;
            break;
        }
    }
}