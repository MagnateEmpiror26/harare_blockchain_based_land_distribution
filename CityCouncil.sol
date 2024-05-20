// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CityCouncil {
    address public owner;
    mapping(uint256 => address) public landOwners;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function grantLandOwnership(uint256 landId, address newOwner) public onlyOwner {
        landOwners[landId] = newOwner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}
