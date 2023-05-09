// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract lottery{

    address payable []  Applications;
    string [] emails;
    address payable owner;

    mapping(string => address) hasApplied;

    constructor () {
        owner = payable(msg.sender);
    }

    function Apply(string memory _email)  payable public {
        require(hasApplied[_email] == address(0), "bYou have already applied"); 
        require(msg.value == 2 ether, "must pay 2 ether to enter");       

        Applications.push(payable(msg.sender));
        emails.push(_email);
        hasApplied[_email] = msg.sender;
    }

    function random() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, Applications.length)));
    }

    function pickWinner () public returns (string memory) {

        require(msg.sender ==owner, "only owner can call this function");

        uint index = random() % Applications.length;
        Applications[index].transfer(address(this).balance);
        Applications = new address payable[](0);

        return emails[index];
    }

    function getApplications () public view returns (address payable[] memory ) {
        return Applications;
    }
}