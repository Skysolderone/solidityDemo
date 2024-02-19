// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Base{
    function privateFunc()private pure returns(string memory){
        return "private function called";
    }
    function testPrivateFunc()public pure returns(string memory){
        return privateFunc();
    }
    function internalFunc()public pure returns(string memory){
        return "internal function called";
    }
    function testInterFunc()public pure virtual returns(string memory){
        return internalFunc();
    }
}