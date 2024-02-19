// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A{
    event Log(string message);
    function foo()public virtual {
        emit Log("A.foo called");
    }
    function bar()public virtual{
        emit Log("A bar called");
        
    }
}

contract B is A {
    function foo()public virtual override {
        emit Log("B.foo called");
    }
    function bar()public virtual override {
        emit Log("C.bar called");
        super.bar();
    }
}
contract C is A{
    function foo()public virtual override {
        emit Log("C.foo called");
    }
    function bar() public virtual  override {
        emit Log("C.bar called");
        super.bar();
    }
}

contract D is B,C{
    function foo() public virtual override (B,C){
        super.foo();
    }
    function bar()public virtual override (B,C){
        super.bar();
    }
}