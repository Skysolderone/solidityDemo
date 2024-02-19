// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract Lottery{
    address payable[] public players;
    address public manager;

    constructor(){
        manager=msg.sender;
    }
    receive() external payable {
        require(msg.value==0.1 ether,"money minnum  0.1 ether");
        address payable send=payable(msg.sender);
        players.push(payable(send));
     }
    // fallback() external payable { 
    //     players.push(payable(msg.sender));
    // }
     function getBalance()public view returns(uint){
        require(msg.sender==manager);
        return address(this).balance;
     }
     function random() public  view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
     }
     function  getWinter()public{
        require(msg.sender==manager,"sender is not owner");
        require(players.length>=3,"players not enough");
        uint r=random();
        uint index=r%players.length;
        address payable winter=players[index];
        winter.transfer(getBalance());
        players=new address payable[](0);
     }
}