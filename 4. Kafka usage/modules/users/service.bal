import kafka_usage.database;
import kafka_usage.types;

import ballerina/http;
import ballerina/persist;
import ballerina/time;
import ballerinax/kafka;
import ballerinax/redis;

configurable int usersPort = ?;

configurable string redisHost = ?;
configurable int redisPort = ?;

// configurable string kafkaHost = ?;
// configurable int kafkaPort = ?;

service on new http:Listener(usersPort) {
    private final redis:Client redis;
    private final database:Client 'client;

    public function init() returns error? {
        self.redis = check new ({
            connection: {
                host: redisHost,
                port: redisPort
            }
        });

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

service on new kafka:Listener(kafka:DEFAULT_URL, {
    groupId: "polls-group-id",
    topics: "poll-user"
}) {
    private final kafka:Producer producer;
    private final database:Client 'client;

    public function init() returns error? {
        self.producer = check new (kafka:DEFAULT_URL);
        self.'client = check new ();
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
