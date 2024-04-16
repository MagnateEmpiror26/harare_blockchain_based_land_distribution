pragma solidity ^0.8.0;

contract DeedOfTransfer {
    // Struct to represent a land transfer
    struct LandTransfer {
        address previousOwner;
        address newOwner;
        string deedId;
        uint256 dateTransferred;
        uint256 landSize;
        bool completed;
        mapping(address => bool) signatures; // Mapping to store digital signatures
    }

    // Mapping to store land transfers with a unique identifier
    mapping(bytes32 => LandTransfer) public landTransfers;

    // Event to log transfer initiation
    event TransferInitiated(bytes32 indexed transferId, address indexed previousOwner, address indexed newOwner, string deedId, uint256 landSize);

    // Event to log transfer completion
    event TransferCompleted(bytes32 indexed transferId);

    // Event to log digital signature
    event SignatureAdded(bytes32 indexed transferId, address indexed signer);

    // Modifier to restrict access to certain functions
    modifier onlyPreviousOwner(bytes32 transferId) {
        require(landTransfers[transferId].previousOwner == msg.sender, "You are not the previous owner of this land");
        _;
    }

    // Function to initiate a land transfer
    function initiateTransfer(
        bytes32 transferId,
        address newOwner,
        string memory deedId,
        uint256 landSize
    ) external {
        require(landTransfers[transferId].previousOwner == address(0), "Transfer ID already exists");

        LandTransfer storage newTransfer = landTransfers[transferId];
        newTransfer.previousOwner = msg.sender;
        newTransfer.newOwner = newOwner;
        newTransfer.deedId = deedId;
        newTransfer.dateTransferred = block.timestamp;
        newTransfer.landSize = landSize;
        newTransfer.completed = false;

        emit TransferInitiated(transferId, msg.sender, newOwner, deedId, landSize);
    }

    // Function to complete a land transfer
    function completeTransfer(bytes32 transferId) external onlyPreviousOwner(transferId) {
        landTransfers[transferId].completed = true;
        emit TransferCompleted(transferId);
    }

    // Function to add digital signature
    function addSignature(bytes32 transferId) external {
        require(msg.sender == landTransfers[transferId].previousOwner || msg.sender == landTransfers[transferId].newOwner, "You are not authorized to sign this transfer");
        require(!landTransfers[transferId].signatures[msg.sender], "Signature already added");

        landTransfers[transferId].signatures[msg.sender] = true;
        emit SignatureAdded(transferId, msg.sender);
    }
}
