import users_service.database;

import ballerina/http;
import ballerina/persist;

configurable int port = ?;

@http:ServiceConfig {
    auth: [
        {
            jwtValidatorConfig: {
                issuer: "wso2",
                audience: "ballerina",
                signatureConfig: {
                    certFile: "/path/to/public.crt"
                },
                scopeKey: "scp"
            },
            scopes: ["admin"]
        }
    ]
}
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

