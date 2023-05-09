// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract lottery{

    address payable  []  Applications;
    string [] names;
    address payable owner;

    mapping(string => address) public hasApplied;

    constructor () {

        owner = payable(msg.sender);
    }

    function Apply(string memory _name , address _addr)  payable public {
        require(hasApplied[_name] == address(0), "b"); 
        require(msg.value == 2 ether, "must pay 2 ether to enter");       

        Applications.push(payable(msg.sender));
        names.push(_name);
        hasApplied[_name] = msg.sender;
    }

    function random() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, Applications.length)));
    }

    function pickWinner () public  {

        require(msg.sender ==owner, "only owner can call this function");

        uint index = random() % Applications.length;
        Applications[index].transfer(address(this).balance);
        Applications = new address payable[](0);
    }

    function getApplications () public view returns (address payable[] memory ) {
        return Applications;
    }
}