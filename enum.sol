// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Enum {
    enum Status{
        Pending,
        Shipped,
        Acceped,
        Rejected,
        Canceled
    }
    Status public status;
    function get() public view returns (Status){
        return status;
    }
    function cancel()public {
        status=Status.Canceled;
    }
    function reset()public {
        delete status;
    }
}