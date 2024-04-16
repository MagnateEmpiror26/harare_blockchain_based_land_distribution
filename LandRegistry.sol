pragma solidity ^0.8.0;

contract LandRegistry {
    // Struct to represent land information
    struct LandInfo {
        string deedId;
        uint256 landSize;
        string landAddress;
        string district;
        string generalPlanNumber;
        address owner;
        bool verified;
    }

    // Mapping to store land information with a unique identifier
    mapping(bytes32 => LandInfo) public landRecords;

    // Address of the authority who can verify land information
    address public authorityAddress;

    // Event to log land registration
    event LandRegistered(bytes32 indexed recordId, string deedId, address indexed owner);

    // Modifier to restrict access to certain functions
    modifier onlyVerified(bytes32 recordId) {
        require(landRecords[recordId].verified, "Land information is not verified");
        _;
    }

    // Modifier to restrict access to authority functions
    modifier onlyAuthority() {
        require(msg.sender == authorityAddress, "You are not authorized to perform this action");
        _;
    }

    // Constructor to set the authority address
    constructor() {
        authorityAddress = msg.sender;
    }

    // Function to register land information
    function registerLand(
        bytes32 recordId,
        string memory deedId,
        uint256 landSize,
        string memory landAddress,
        string memory district,
        string memory generalPlanNumber,
        address owner,
        bool verified
    ) external {
        require(landRecords[recordId].owner == address(0), "Record ID already exists");

        landRecords[recordId] = LandInfo({
            deedId: deedId,
            landSize: landSize,
            landAddress: landAddress,
            district: district,
            generalPlanNumber: generalPlanNumber,
            owner: owner,
            verified: verified
        });

        emit LandRegistered(recordId, deedId, owner);
    }

    // Function to get land information
    function getLandInfo(bytes32 recordId) external view onlyVerified(recordId) returns (LandInfo memory) {
        return landRecords[recordId];
    }

    // Function to verify land information
    function verifyLand(bytes32 recordId) external onlyAuthority {
        landRecords[recordId].verified = true;
    }

    // Function to check if a record exists
    function recordExists(bytes32 recordId) external view returns (bool) {
        return landRecords[recordId].owner != address(0);
    }

    // Function to transfer ownership of land information
    function transferOwnership(bytes32 recordId, address newOwner) external {
        require(msg.sender == landRecords[recordId].owner, "You are not the owner of this land");
        landRecords[recordId].owner = newOwner;
    }
}

