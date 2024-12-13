import ballerina/test;

@test:Config
public function testGetUsers() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    User[] users = [
        {
            id: "1",
            name: "User 1",
            email: "user1@example.com",
            registeredObjects: 10
        },
        {
            id: "2",
            name: "User 2",
            email: "user2@example.com",
            registeredObjects: 5
        }
    ];

    test:prepare(databaseClient)
        .whenResource("users")
        .onMethod("get")
        .thenReturn(users);

    UsersClientStub usersClient = new ();
    usersClient.databaseClient = databaseClient;

    var response = usersClient->/users();

    test:assertTrue(response is User[]);
    test:assertExactEquals(response, users);
}

@test:Config
public function testGetUserById() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    User user = {
        id: "1",
        name: "User 1",
        email: "user1@example.com",
        registeredObjects: 10
    };

    test:prepare(databaseClient)
        .whenResource("users/:id")
        .onMethod("get")
        .withPathParameters({id: "1"})
        .thenReturn(user);

    UsersClientStub usersClient = new ();
    usersClient.databaseClient = databaseClient;

    var response = usersClient->/users/["1"]();

    test:assertTrue(response is User);
    test:assertExactEquals(response, user);
}

@test:Config
public function testGetUserByIdNotFound() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    var mockError = error("User not found");

    test:prepare(databaseClient)
        .whenResource("users/:id")
        .onMethod("get")
        .withPathParameters({id: "1"})
        .thenReturn(mockError);

    UsersClientStub usersClient = new ();
    usersClient.databaseClient = databaseClient;

    var response = usersClient->/users/["1"]();

    test:assertTrue(response is error);
    test:assertExactEquals(response, mockError);
}

@test:Config
public function testPostUsers() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    UserInsert[] insertUsers = [
        {
            id: "1",
            name: "User 1",
            email: "user1@example.com",
            registeredObjects: 10
        },
        {
            id: "2",
            name: "User 2",
            email: "user2@example.com",
            registeredObjects: 5
        }
    ];

    string[] generatedIds = ["1", "2"];

    test:prepare(databaseClient)
        .whenResource("users")
        .onMethod("post")
        .withArguments(insertUsers)
        .thenReturn(generatedIds);

    UsersClientStub usersClient = new ();
    usersClient.databaseClient = databaseClient;

    var response = usersClient->/users.post(insertUsers);

    test:assertTrue(response is string[]);
    test:assertExactEquals(response, generatedIds);
}

@test:Config
public function testPostUsersError() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    UserInsert[] insertUsers = [
        {
            id: "1",
            name: "User 1",
            email: "user1@example.com",
            registeredObjects: 10
        },
        {
            id: "2",
            name: "User 2",
            email: "user2@example.com",
            registeredObjects: 5
        }
    ];

    var mockError = error("Failed to add users");

    test:prepare(databaseClient)
        .whenResource("users")
        .onMethod("post")
        .withArguments(insertUsers)
        .thenReturn(mockError);

    UsersClientStub usersClient = new ();
    usersClient.databaseClient = databaseClient;

    var response = usersClient->/users.post(insertUsers);

    test:assertTrue(response is error);
    test:assertExactEquals(response, mockError);
}

@test:Config
public function testPutUser() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    UserUpdate updateUser = {
        name: "Updated User"
    };
    User updatedUser = {
        id: "1",
        name: "Updated User",
        email: "user1@example.com",
        registeredObjects: 10
    };

    test:prepare(databaseClient)
        .whenResource("users/:id")
        .onMethod("put")
        .withPathParameters({id: "1"})
        .withArguments(updateUser)
        .thenReturn(updatedUser);

    UsersClientStub usersClient = new ();
    usersClient.databaseClient = databaseClient;

    var response = usersClient->/users/["1"].put(updateUser);

    test:assertTrue(response is User);
    test:assertExactEquals(response, updatedUser);
}

@test:Config
public function testPutUserError() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    UserUpdate updateUser = {
        name: "Updated User"
    };
    var mockError = error("Failed to update user");

    test:prepare(databaseClient)
        .whenResource("users/:id")
        .onMethod("put")
        .withPathParameters({id: "1"})
        .withArguments(updateUser)
        .thenReturn(mockError);

    UsersClientStub usersClient = new ();
    usersClient.databaseClient = databaseClient;
    var response = usersClient->/users/["1"].put(updateUser);

    test:assertTrue(response is error);
    test:assertExactEquals(response, mockError);
}

@test:Config
public function testDeleteUser() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    User deletedUser = {
        id: "1",
        name: "User 1",
        email: "user1@example.com",
        registeredObjects: 10
    };

    test:prepare(databaseClient)
        .whenResource("users/:id")
        .onMethod("delete")
        .withPathParameters({id: "1"})
        .thenReturn(deletedUser);

    UsersClientStub usersClient = new ();
    usersClient.databaseClient = databaseClient;

    var response = usersClient->/users/["1"].delete();

    test:assertTrue(response is User);
    test:assertExactEquals(response, deletedUser);
}

@test:Config
public function testDeleteUserError() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    var mockError = error("Failed to delete user");

    test:prepare(databaseClient)
        .whenResource("users/:id")
        .onMethod("delete")
        .withPathParameters({id: "1"})
        .thenReturn(mockError);

    UsersClientStub usersClient = new ();
    usersClient.databaseClient = databaseClient;

    var response = usersClient->/users/["1"].delete();

    test:assertTrue(response is error);
    test:assertExactEquals(response, mockError);
}
