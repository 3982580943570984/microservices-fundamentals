import ballerina/http;
import ballerina/uuid;
import ballerinax/mongodb;

configurable string host = "localhost";
configurable int port = 27017;

final mongodb:Client mongoDb = check new ({
    connection: {
        serverAddress: {
            host: host,
            port: port
        },
        auth: null
    }
});

service on new http:Listener(8080) {
    private final mongodb:Database pollsDb;

    function init() returns error? {
        self.pollsDb = check mongoDb->getDatabase("polls");
    }

    resource function get polls() returns PollEntry[]|error {
        mongodb:Collection pollEntries = check self.pollsDb->getCollection("pollEntries");

        stream<PollEntry, error?> findResult = check pollEntries->find();

        return check from PollEntry pollEntry in findResult
            select pollEntry;
    }

    resource function get polls/[string id]() returns PollEntry|error {
        mongodb:Collection pollEntries = check self.pollsDb->getCollection("pollEntries");

        stream<PollEntry, error?> findResult = check pollEntries->find({id});

        PollEntry[] result = check from PollEntry pollEntry in findResult
            select pollEntry;

        if result.length() != 1 {
            return error(string `Failed to find poll with id ${id}`);
        }

        return result[0];
    }

    resource function post polls(Poll poll) returns PollEntry|error {
        string id = uuid:createType1AsString();

        PollEntry pollEntry = {id, ...poll};

        mongodb:Collection pollEntries = check self.pollsDb->getCollection("pollEntries");

        check pollEntries->insertOne(pollEntry);

        return pollEntry;
    }

    resource function put polls/[string id](Poll poll) returns PollEntry|error {
        mongodb:Collection pollEntries = check self.pollsDb->getCollection("pollEntries");

        mongodb:UpdateResult updateResult = check pollEntries->updateOne({id}, {set: poll});

        if updateResult.modifiedCount != 1 {
            return error(string `Failed to update the poll with id ${id}`);
        }

        stream<PollEntry, error?> findResult = check pollEntries->find({id});

        PollEntry[] result = check from PollEntry pollEntry in findResult
            select pollEntry;

        if result.length() != 1 {
            return error(string `Failed to find poll with id ${id}`);
        }

        return result[0];
    }

    resource function delete polls/[string id]() returns string|error {
        mongodb:Collection pollEntries = check self.pollsDb->getCollection("pollEntries");

        mongodb:DeleteResult deleteResult = check pollEntries->deleteOne({id});

        if deleteResult.deletedCount != 1 {
            return error(string `Failed to delete the movie with id ${id}`);
        }

        return id;
    }
}

public type Vote record {|
    string option;
    int answers;
|};

public type Poll record {|
    string question;
    Vote[] votes;
|};

public type PollEntry record {|
    readonly string id;
    *Poll;
|};
