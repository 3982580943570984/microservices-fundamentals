import users_service.database;

import ballerina/http;
import ballerina/persist;
import ballerina/time;
import ballerinax/kafka;

import nixos/shared_types as types;

configurable int port = ?;

configurable string kafkaHost = ?;
configurable int kafkaPort = ?;

service on new http:Listener(port) {
    private final database:Client 'client;

    public function init() returns error? {
        self.'client = check new ();
    }

    resource function get users() returns database:User[]|error? {
        stream<database:User, persist:Error?> users = self.'client->/users;
        return check from var user in users
            select user;
    }

    resource function get users/[string id]() returns database:User|error? {
        database:User user = check self.'client->/users/id;
        return user;
    }

    resource function post users(database:UserInsert[] users) returns string[]|error? {
        string[] ids = check self.'client->/users.post(users);
        return ids;
    }

    resource function put users/[string id](database:UserUpdate user) returns database:User|error? {
        database:User updatedUser = check self.'client->/users/id.put(user);
        return updatedUser;
    }

    resource function delete users/[string id]() returns database:User|error? {
        database:User deletedUser = check self.'client->/users/id.delete;
        return deletedUser;
    }
}

service on new kafka:Listener(string `${kafkaHost}:${kafkaPort}`, {
    groupId: "polls-group-id",
    topics: "poll-user"
}) {
    private final database:Client 'client;
    private final kafka:Producer producer;

    public function init() returns error? {
        self.'client = check new ();
        self.producer = check new (string `${kafkaHost}:${kafkaPort}`);
    }

    remote function onConsumerRecord(types:Confirmation[] confirmations) returns error? {
        from types:Confirmation confirmation in confirmations
        do {
            string userId = confirmation.userId;

            database:User user = check self.'client->/users/[userId];

            user.registeredObjects += 1;

            database:UserUpdate userUpdate = {
                registeredObjects: user.registeredObjects
            };

            _ = check self.'client->/users/[userId].put(userUpdate);

            types:Response response = {
                objectId: confirmation.objectId,
                updateTime: time:utcToString(time:utcNow())
            };

            check self.producer->send({
                topic: "user-poll",
                value: response
            });
        };
    }
}
