import ballerina/persist as _;

public type User record {|
    readonly string id;
    string name;
    string email;
    int registeredObjects;
|};
