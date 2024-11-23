// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

public type Poll record {|
    readonly string id;
    string question;

    string userId;
    string registrationTimestamp;
|};

public type PollOptionalized record {|
    string id?;
    string question?;
    string userId?;
    string registrationTimestamp?;
|};

public type PollWithRelations record {|
    *PollOptionalized;
    VoteOptionalized[] votes?;
|};

public type PollTargetType typedesc<PollWithRelations>;

public type PollInsert Poll;

public type PollUpdate record {|
    string question?;
    string userId?;
    string registrationTimestamp?;
|};

public type Vote record {|
    readonly string id;
    string option;
    int answers;
    string pollId;
|};

public type VoteOptionalized record {|
    string id?;
    string option?;
    int answers?;
    string pollId?;
|};

public type VoteWithRelations record {|
    *VoteOptionalized;
    PollOptionalized poll?;
|};

public type VoteTargetType typedesc<VoteWithRelations>;

public type VoteInsert Vote;

public type VoteUpdate record {|
    string option?;
    int answers?;
    string pollId?;
|};

