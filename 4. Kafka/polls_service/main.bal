import polls_service.database;

import ballerina/http;
import ballerina/persist;
import ballerinax/kafka;

import nixos/shared_types as types;

configurable int port = ?;

configurable string kafkaHost = ?;
configurable int kafkaPort = ?;

service on new http:Listener(port) {
    private final kafka:Producer producer;
    private final database:Client 'client;

    public function init() returns error? {
        self.producer = check new (string `${kafkaHost}:${kafkaPort}`);
        self.'client = check new ();
    };

    resource function get polls() returns database:Poll[]|error? {
        stream<database:Poll, persist:Error?> polls = self.'client->/polls;
        return check from var poll in polls
            select poll;
    }

    resource function get polls/[string id]() returns database:Poll|error? {
        database:Poll poll = check self.'client->/polls/id;
        return poll;
    }

    resource function post polls(database:PollInsert[] polls) returns string[]|error? {
        string[] ids = check self.'client->/polls.post(polls);

        foreach string id in ids {
            types:Confirmation confirmation = {
                objectId: id,
                userId: polls.filter(p => p.id == id)[0].userId
            };

            check self.producer->send({
                topic: "poll-user",
                value: confirmation
            });
        }

        return ids;
    }

    resource function put polls/[string id](database:PollUpdate poll) returns database:Poll|error? {
        database:Poll updatedPoll = check self.'client->/polls/id.put(poll);
        return updatedPoll;
    }

    resource function delete polls/[string id]() returns database:Poll|error? {
        database:Poll deletedPoll = check self.'client->/polls/id.delete;
        return deletedPoll;
    }
}

service on new kafka:Listener(string `${kafkaHost}:${kafkaPort}`, {
    groupId: "user-group-id",
    topics: "user-poll"
}) {
    private final kafka:Producer producer;
    private final database:Client 'client;

    public function init() returns error? {
        self.producer = check new (string `${kafkaHost}:${kafkaPort}`);
        self.'client = check new ();
    }

    remote function onConsumerRecord(types:Response[] responses) returns error? {
        from types:Response response in responses
        do {
            string objectId = response.objectId;

            database:PollUpdate pollUpdate = {
                registrationTimestamp: response.updateTime
            };

            _ = check self.'client->/polls/[objectId].put(pollUpdate);
        };
    }
}
