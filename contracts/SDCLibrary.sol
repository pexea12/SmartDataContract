pragma solidity ^0.5.0;

library SDCLibrary {
    enum RoleType {
        DC,
        AC
    }
    
    enum ConsensusStatus {
        OPT_IN,
        OPT_OUT
    }
    
    enum FileFormat {
        CSV,
        JSON,
        BINARY
    }
    
    enum DataType {
        LOCATION,
        ACTIVITY
    }
   
    
    struct Organizer {
        RoleType role;
        address vendorId;
        uint joinedAt;
        uint exitedAt;
    }
    
    struct Creator {
        RoleType role;
        address vendorId;
        uint joinedAt;
        uint exitedAt;
    }
    
    struct Subscriber {
        RoleType role;
        address vendorId;
    }
    
    struct Investor {
        address podId;
        uint joinedAt;
        uint exitedAt;
        ConsensusStatus consensus;
    }
    
    struct DataCollectionInfo {
        DataType dataType;
        FileFormat format;
        uint size;
        uint8 timeRange;
    }
    
    struct AlgorithmRequirement {
        DataType dataType;
        FileFormat format;
        uint minSize;
        string environment;
        string dependencies;
    }
    
    enum ErrorLevel {
        INFO,
        WARNING,
        ERROR
    }
    
    enum ErrorType {
        DATA,
        ALGORITHM,
        NETWORK,
        SERVER
    }
    
    struct Error {
        ErrorLevel level;
        ErrorType errorType;
        string message;
    }
    
    enum ReportedInfoLevel {
        LOW,
        MEDIUM,
        HIGH
    }
    
    enum ReportedInfoType {
        DATA,
        ALGORITHM,
        PAYMENT
    }
    
    struct ReportedInfo {
        ReportedInfoLevel level;
        ReportedInfoType infoType;
        string message;
    }
}
