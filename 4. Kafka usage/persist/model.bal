import ballerina/persist as _;

public type Poll record {|
    readonly string id;
    string question;
    Vote[] votes;
    string userId;
    string registrationTimestamp;
|};

public type Vote record {|
    readonly string id;
    string option;
    int answers;
    Poll poll;
|};

public type User record {|
    readonly string id;
    string name;
    string email;
    int registeredObjects;
|};
