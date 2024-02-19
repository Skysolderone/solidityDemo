// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract  SimpleStorage{
    uint public num=5;
    bool public boolean=true;
    string public str="hello,world";
    bytes32 public bye="hello,world";
    address public add=0x35A42428a5446E35158b90D6339F8eAaEf95c272;
    struct People {
       string Name;
       uint num;
    }
    People[] public peo;
    mapping(string=>uint) public peomap;
    function peoSto(string memory _name,uint _num)public {
        peo.push(People(_name,_num));
        peomap[_name]=_num;
    }
}