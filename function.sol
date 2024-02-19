// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Function{
    function returnMany()public pure returns (uint,bool,uint){
        return (1,true,2);
    }
    function named()public pure returns (uint x,bool b,uint y){
        return (1,true,2);
    }
    function assinged()public pure returns (uint x,bool b,uint y){
        x=1;b=true;y=2;
    }
    function destrucingAssignments()public pure returns (uint ,bool,uint,uint,uint){
        (uint i,bool b ,uint j)=returnMany();
        (uint x, ,uint y)=(4,5,6);
        return (i,b,j,x,y);
    }
    function arrayInPut(uint[] memory _arr)public{}
    uint[] public arr;
    function arrayOutPut()public view returns(uint[] memory){
            return arr;
    }

    

}

contract XYZ{
    function someFuncWithManyInputs(
        uint x,uint y,uint z,address a,bool b,string memory c 
    )public pure returns (uint){}
}