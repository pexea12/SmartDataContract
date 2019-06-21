pragma solidity ^0.5.0;

import "./SDCLibrary.sol";


contract SDC {
    using SDCLibrary for *;
    
    enum SDCStatus {
        DEFINITION,
        BACKTEST,
        CONTRACTING,
        FUNDING,
        PUBLISHED,
        SUBSCRIBED,
        SUSPENDED,
        CANCELLED,
        EXPIRED,
        TERMINATED
    }
    
    struct SingleSDC {
        uint version;
        SDCStatus status;
        string purpose;
        
        uint createdAt;
        uint updatedAt;
        uint publishedAt;
        uint subscribedAt;
        uint suspendedAt;
        uint terminatedAt;
        uint cancelledAt;
        uint expiredAt;
    }
    
    SingleSDC[] public contracts;
    // error mapping contractId => error
    mapping(uint => SDCLibrary.Error[]) public errors;
    // info mapping contractId => info
    mapping(uint => SDCLibrary.ReportedInfo[]) public infos;
    mapping(uint => SDCLibrary.Organizer) public organizers;
    mapping(uint => SDCLibrary.Creator[]) public creators;
    mapping(uint => SDCLibrary.Subscriber[]) public subscribers;
    mapping(uint => SDCLibrary.Investor[]) public investors;
    mapping(uint => SDCLibrary.DataCollectionInfo[]) public dataSources;
    mapping(uint => SDCLibrary.AlgorithmRequirement[]) public algorithms;
    
    
    function createSDC(
        uint _version,
        string memory _purpose,
        uint _expiredAt,
        SDCLibrary.RoleType _organizerRole
    ) 
        public 
        payable 
        hasValue()
        validExpireAt(_expiredAt)
        returns (uint) {
            
        contracts.push(SingleSDC(
            _version,
            SDCStatus.DEFINITION,
            _purpose,
            now,
            now,
            0,
            0,
            0,
            0,
            0,
            _expiredAt
        ));
        
        organizers[contracts.length - 1] = SDCLibrary.Organizer(
            _organizerRole,
            msg.sender,
            now,
            0
        );
        
        return (contracts.length - 1);
    }
    
    function addCreator(
        uint contractId, 
        SDCLibrary.RoleType _creatorType,
        address _creatorAddress
    ) public isOwner(contractId) {
        creators[contractId].push(SDCLibrary.Creator(
            _creatorType,
            _creatorAddress,
            now,
            0
        ));
    }
    
    function addSubscriber(
        uint contractId, 
        SDCLibrary.RoleType _subscriberType,
        address _subscriberAddress
    ) public isOwner(contractId) {
        subscribers[contractId].push(SDCLibrary.Subscriber(
            _subscriberType,
            _subscriberAddress
        ));
        
        contracts[contractId].status = SDCStatus.SUBSCRIBED;
    }
    
    function addInvestor(
        uint contractId, 
        address _investorAddress,
        SDCLibrary.ConsensusStatus _investorConsensusStatus
    ) public isOwner(contractId) {
        investors[contractId].push(SDCLibrary.Investor(
            _investorAddress,
            now,
            0,
            _investorConsensusStatus
        ));
    }
    
    function addDataSource(
        uint contractId,
        SDCLibrary.DataType _dataType,
        SDCLibrary.FileFormat _format,
        uint _size,
        uint8 _timeRange
    ) public isOwner(contractId) {
        dataSources[contractId].push(SDCLibrary.DataCollectionInfo(
            _dataType,
            _format,
            _size,
            _timeRange
        ));
    }
    
    function addAlgorithmRequirement(
        uint contractId,
        SDCLibrary.DataType _dataType,
        SDCLibrary.FileFormat _format,
        uint _minSize,
        string memory _environment,
        string memory _dependencies
    ) public isOwner(contractId) {
        algorithms[contractId].push(SDCLibrary.AlgorithmRequirement(
            _dataType,
            _format,
            _minSize,
            _environment,
            _dependencies
        ));
    }
    
    function setFundingStatus(uint contractId) 
        public isOwner(contractId) {
        contracts[contractId].status = SDCStatus.FUNDING;
    }
    
    function publishContract(uint contractId) 
        public isOwner(contractId) {
        contracts[contractId].status = SDCStatus.PUBLISHED;
        contracts[contractId].publishedAt = now;
    }
    
    modifier hasValue() {
        require(msg.value > 0);
        _;
    }
    
    modifier validExpireAt(uint _expiredAt) {
        require(_expiredAt > now);
        _;
    }
    
    modifier isOwner(uint contractId) {
        require(organizers[contractId].vendorId == msg.sender);
        _;
    }
}
