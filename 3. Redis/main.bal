import ballerina/http;
import ballerina/log;
import ballerina/uuid;
import ballerinax/mongodb;
import ballerinax/redis;

configurable string mongoDbHost = "localhost";
configurable int mongoDbPort = 27017;

final mongodb:Client mongoDb = check new ({
    connection: {
        serverAddress: {
            host: mongoDbHost,
            port: mongoDbPort
        },
        auth: null
    }
});

configurable string redisHost = "localhost";
configurable int redisPort = 6379;

final redis:Client redis = check new ({
    connection: {
        host: redisHost,
        port: redisPort
    }
});

service on new http:Listener(8080) {
    private final mongodb:Database pollsDb;

    function init() returns error? {
        self.pollsDb = check mongoDb->getDatabase("polls");
    }

    resource function get polls() returns PollEntry[]|error {
        string cacheKey = "polls:all";

        string? cachedData = check redis->get(cacheKey);

        if cachedData is string {
            log:printInfo(string `Cache hit for key: ${cacheKey}`);

            _ = check redis->expire(cacheKey, 60);

            PollEntry[] pollEntries = check (check cachedData.fromBalString()).cloneWithType();

            return pollEntries;
        }

        log:printInfo(string `Cache miss for key: ${cacheKey}`);

        mongodb:Collection pollEntries = check self.pollsDb->getCollection("pollEntries");

        stream<PollEntry, error?> findResult = check pollEntries->find();

        PollEntry[] result = check from PollEntry pollEntry in findResult
            select pollEntry;

        _ = check redis->setEx(cacheKey, result.toBalString(), expirationTime = 60);

        return result;
    }

    resource function get polls/[string id]() returns PollEntry|error {
        string cacheKey = string `polls:${id}`;

        string? cachedData = check redis->get(cacheKey);

        if cachedData is string {
            log:printInfo(string `Cache hit for key: ${cacheKey}`);

            _ = check redis->expire(cacheKey, 60);

            PollEntry pollEntry = check (check cachedData.fromBalString()).cloneWithType();

            return pollEntry;
        }

        log:printInfo(string `Cache miss for key: ${cacheKey}`);

        mongodb:Collection pollEntries = check self.pollsDb->getCollection("pollEntries");

        stream<PollEntry, error?> findResult = check pollEntries->find({id});

        PollEntry[] result = check from PollEntry pollEntry in findResult
            select pollEntry;

        if result.length() != 1 {
            return error(string `Failed to find poll with id ${id}`);
        }

        PollEntry pollEntry = result[0];

        _ = check redis->setEx(cacheKey, pollEntry.toBalString(), expirationTime = 60);

        return pollEntry;
    }

    resource function post polls(Poll poll) returns PollEntry|error {
        string id = uuid:createType1AsString();

        PollEntry pollEntry = {id, ...poll};

        mongodb:Collection pollEntries = check self.pollsDb->getCollection("pollEntries");

        check pollEntries->insertOne(pollEntry);

        string cacheKey = "polls:all";

        log:printInfo(string `Cache delete for key: ${cacheKey}`);

        _ = check redis->del([cacheKey]);

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

        PollEntry updatedPoll = result[0];

        string cacheKey = string `polls:${updatedPoll.id}`;

        log:printInfo(string `Cache update for key: ${cacheKey}`);

        _ = check redis->setEx(cacheKey, updatedPoll.toBalString(), expirationTime = 60);

        cacheKey = "polls:all";

        log:printInfo(string `Cache delete for key: ${cacheKey}`);

        _ = check redis->del([cacheKey]);

        return result[0];
    }

    resource function delete polls/[string id]() returns string|error {
        mongodb:Collection pollEntries = check self.pollsDb->getCollection("pollEntries");

        mongodb:DeleteResult deleteResult = check pollEntries->deleteOne({id});

        if deleteResult.deletedCount != 1 {
            return error(string `Failed to delete the poll with id ${id}`);
        }

        string[] cacheKeys = [string `polls:${id}`, "polls:all"];

        log:printInfo(string `Cache delete for keys: ${cacheKeys.toString()}`);

        _ = check redis->del(cacheKeys);

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
