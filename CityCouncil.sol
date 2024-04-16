pragma solidity ^0.8.0;

import "./LandRegistry.sol";

contract CityCouncil {
    address public landRegistryAddress;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor(address _landRegistryAddress) {
        landRegistryAddress = _landRegistryAddress;
        owner = msg.sender;
    }

    function registerLand(
        bytes32 recordId,
        string memory deedId,
        uint256 landSize,
        string memory landAddress,
        string memory district,
        string memory generalPlanNumber,
        address owner,
        bool verified
    ) external onlyOwner {
        LandRegistry landRegistry = LandRegistry(landRegistryAddress);
        landRegistry.registerLand(recordId, deedId, landSize, landAddress, district, generalPlanNumber, owner, verified);
    }

    function verifyLand(bytes32 recordId) external onlyOwner {
        LandRegistry landRegistry = LandRegistry(landRegistryAddress);
        landRegistry.verifyLand(recordId);
    }

    function issueDeedOfGrant(
        bytes32 recordId,
        string memory deedId,
        uint256 landSize,
        string memory landAddress,
        string memory district,
        string memory generalPlanNumber,
        address owner,
        bool verified
    ) external onlyOwner {
        LandRegistry landRegistry = LandRegistry(landRegistryAddress);
        landRegistry.registerLand(recordId, deedId, landSize, landAddress, district, generalPlanNumber, owner, verified);
        // Additional logic for issuing deed of grant
    }

    
}
