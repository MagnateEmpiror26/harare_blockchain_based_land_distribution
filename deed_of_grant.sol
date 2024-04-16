pragma solidity ^0.8.0;

contract DeedOfGrant {
    // Struct to represent a land deed
    struct LandDeed {
        address owner;
        string GPNumber;
        uint256 dateIssued;
        string ownerName;
        uint256 landSize;
        string landAddress;
        string district;
        string generalPlanNumber;
        bool verifiedByLocalAuthority;
        bool verifiedBySurveyorGeneral;
    }

    // Mapping to store land deeds with a unique identifier
    mapping(bytes32 => LandDeed) public landDeeds;

    // Event to log deed creation
    event DeedCreated(bytes32 indexed deedId, address indexed owner, string GPNumber, uint256 dateIssued);

    // Event to log deed verification
    event DeedVerified(bytes32 indexed deedId, string verifier);

    // Modifier to restrict access to certain functions
    modifier onlyOwner(bytes32 deedId) {
        require(landDeeds[deedId].owner == msg.sender, "You are not the owner of this deed");
        _;
    }

    // Function to create a new land deed
    function createDeed(
        bytes32 deedId,
        string memory GPNumber,
        uint256 dateIssued,
        string memory ownerName,
        uint256 landSize,
        string memory landAddress,
        string memory district,
        string memory generalPlanNumber
    ) external {
        require(landDeeds[deedId].owner == address(0), "Deed ID already exists");
        
        landDeeds[deedId] = LandDeed({
            owner: msg.sender,
            GPNumber: GPNumber,
            dateIssued: dateIssued,
            ownerName: ownerName,
            landSize: landSize,
            landAddress: landAddress,
            district: district,
            generalPlanNumber: generalPlanNumber,
            verifiedByLocalAuthority: false,
            verifiedBySurveyorGeneral: false
        });
        emit DeedCreated(deedId, msg.sender, GPNumber, dateIssued);
    }

    // Function to verify a land deed by local authority
    function verifyByLocalAuthority(bytes32 deedId) external {
        require(landDeeds[deedId].owner == msg.sender, "You are not the owner of this deed");
        landDeeds[deedId].verifiedByLocalAuthority = true;
        emit DeedVerified(deedId, "Local Authority");
    }

    // Function to verify a land deed by surveyor general
    function verifyBySurveyorGeneral(bytes32 deedId) external {
        require(landDeeds[deedId].owner == msg.sender, "You are not the owner of this deed");
        landDeeds[deedId].verifiedBySurveyorGeneral = true;
        emit DeedVerified(deedId, "Surveyor General");
    }
}
