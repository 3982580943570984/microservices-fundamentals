import polls_service.database;

import ballerina/http;
import ballerina/persist;

configurable int port = ?;

service on new http:Listener(port) {
    private final database:Client 'client;

    public function init() returns error? {
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
