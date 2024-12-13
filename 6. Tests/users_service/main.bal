// import users_service.database;

// import ballerina/http;
// import ballerina/persist;

// configurable int port = ?;

// service on new http:Listener(port) {
//     private final database:Client 'client;

//     public function init() returns error? {
//         self.'client = check new ();
//     }

//     resource function get users() returns database:User[]|error? {
//         stream<database:User, persist:Error?> users = self.'client->/users;
//         return check from var user in users
//             select user;
//     }

//     resource function get users/[string id]() returns database:User|error? {
//         database:User user = check self.'client->/users/id;
//         return user;
//     }

//     resource function post users(database:UserInsert[] users) returns string[]|error? {
//         string[] ids = check self.'client->/users.post(users);
//         return ids;
//     }

//     resource function put users/[string id](database:UserUpdate user) returns database:User|error? {
//         database:User updatedUser = check self.'client->/users/id.put(user);
//         return updatedUser;
//     }

//     resource function delete users/[string id]() returns database:User|error? {
//         database:User deletedUser = check self.'client->/users/id.delete;
//         return deletedUser;
//     }
// }

public type User record {|
    readonly string id;
    string name;
    string email;
    int registeredObjects;
|};

public type UserInsert User;

public type UserUpdate record {|
    string name?;
    string email?;
    int registeredObjects?;
|};

public client class UsersClientStub {
    public DatabaseClientStub databaseClient = new ();

    resource function get users() returns User[]|error {
        return self.databaseClient->/users;
    }

    resource function get users/[string id]() returns User|error {
        return self.databaseClient->/users/[id];
    }

    resource function post users(UserInsert[] users) returns string[]|error {
        return self.databaseClient->/users.post(users);
    }

    resource function put users/[string id](UserUpdate user) returns User|error {
        return self.databaseClient->/users/[id].put(user);
    }

    resource function delete users/[string id]() returns User|error {
        return self.databaseClient->/users/[id].delete();
    }
}

public client class DatabaseClientStub {
    resource function get users() returns User[]|error {
        return error("Stub method");
    }

    resource function get users/[string id]() returns User|error {
        return error("Stub method");
    }

    resource function post users(UserInsert[] users) returns string[]|error {
        return error("Stub method");
    }

    resource function put users/[string id](UserUpdate user) returns User|error {
        return error("Stub method");
    }

    resource function delete users/[string id]() returns User|error {
        return error("Stub method");
    }
}

