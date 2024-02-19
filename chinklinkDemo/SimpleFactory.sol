// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SimpleStorage.sol";

contract SimpleFactory{
    SimpleStorage[] public simplearray;

    function createcontract()public {
        SimpleStorage simpleStorage=new SimpleStorage();
        simplearray.push(simpleStorage);
    }
}


