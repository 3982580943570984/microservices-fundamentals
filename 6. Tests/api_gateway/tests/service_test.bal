import ballerina/test;

@test:Config
public function testGetJwt() returns error? {
    GatewayClientStub gateway = test:mock(GatewayClientStub);

    string jwt = "";

    test:prepare(gateway)
        .whenResource("jwt")
        .onMethod("get")
        .thenReturn(jwt);

    var response = gateway->/jwt();

    test:assertTrue(response is string);
    test:assertExactEquals(response, jwt);
}

@test:Config
public function testGetUsersWithInvalidJwt() returns error? {
    GatewayClientStub gateway = test:mock(GatewayClientStub);

    json[] returnValue = [{}];

    test:prepare(gateway)
        .whenResource("users")
        .onMethod("get")
        .withArguments("invalid jwt")
        .thenReturn(returnValue);

    var response = gateway->/users(jwt = "invalid jwt");

    test:assertTrue(response is json[]);
    test:assertExactEquals(response, returnValue);
}

@test:Config
public function testGetUsersWithValidJwt() returns error? {
    GatewayClientStub gateway = test:mock(GatewayClientStub);

    test:prepare(gateway)
        .whenResource("jwt")
        .onMethod("get")
        .thenReturn("");

    var jwt = gateway->/jwt();

    test:assertTrue(jwt is string);
    test:assertExactEquals(jwt, "");

    json[] returnValue = [{}];

    test:prepare(gateway)
        .whenResource("users")
        .onMethod("get")
        .thenReturn(returnValue);

    var users = gateway->/users(jwt = check jwt);

    test:assertTrue(users is json[]);
}

@test:Config
public function testGetPollsWithInvalidJwt() returns error? {
    GatewayClientStub gateway = test:mock(GatewayClientStub);

    string invalidJwt = "invalid jwt";
    json[] returnValue = [{}];

    test:prepare(gateway)
        .whenResource("polls")
        .onMethod("get")
        .withArguments(invalidJwt)
        .thenReturn(returnValue);

    var response = gateway->/polls(jwt = invalidJwt);

    test:assertTrue(response is json[]);
    test:assertExactEquals(response, returnValue);
}

@test:Config
public function testGetPollsWithValidJwt() returns error? {
    GatewayClientStub gateway = test:mock(GatewayClientStub);

    test:prepare(gateway)
        .whenResource("jwt")
        .onMethod("get")
        .thenReturn("");

    var jwt = gateway->/jwt();

    test:assertTrue(jwt is string);
    test:assertExactEquals(jwt, "");

    json[] returnValue = [{}];

    test:prepare(gateway)
        .whenResource("polls")
        .onMethod("get")
        .thenReturn(returnValue);

    var polls = gateway->/polls(jwt = check jwt);

    test:assertTrue(polls is json[]);
}

@test:Config
public function testGetJwtReturnsError() returns error? {
    GatewayClientStub gateway = test:mock(GatewayClientStub);

    var returnValue = error("Failed to generate JWT");
    test:prepare(gateway)
        .whenResource("jwt")
        .onMethod("get")
        .thenReturn(returnValue);

    var response = gateway->/jwt();

    test:assertTrue(response is error);
    test:assertExactEquals(response, returnValue);
}

@test:Config
public function testGetUsersReturnsError() returns error? {
    GatewayClientStub gateway = test:mock(GatewayClientStub);

    var returnValue = error("Failed to fetch users");
    test:prepare(gateway)
        .whenResource("users")
        .onMethod("get")
        .withArguments("validJwt")
        .thenReturn(returnValue);

    var response = gateway->/users(jwt = "validJwt");

    test:assertTrue(response is error);
    test:assertExactEquals(response, returnValue);

}

@test:Config
public function testGetUsersWithEmptyJwt() returns error? {
    GatewayClientStub gateway = test:mock(GatewayClientStub);

    var returnValue = error("Failed to validate JWT");
    test:prepare(gateway)
        .whenResource("users")
        .onMethod("get")
        .withArguments("")
        .thenReturn(returnValue);

    var response = gateway->/users(jwt = "");

    test:assertTrue(response is error);
    test:assertExactEquals(response, returnValue);
}

@test:Config
public function testGetPollsReturnsError() returns error? {
    GatewayClientStub gateway = test:mock(GatewayClientStub);

    var returnValue = error("Failed to fetch polls");
    test:prepare(gateway)
        .whenResource("polls")
        .onMethod("get")
        .withArguments("validJwt")
        .thenReturn(returnValue);

    var response = gateway->/polls(jwt = "validJwt");

    test:assertTrue(response is error);
    test:assertExactEquals(response, returnValue);
}

@test:Config
public function testGetPollsWithEmptyJwt() returns error? {
    GatewayClientStub gateway = test:mock(GatewayClientStub);

    var returnValue = error("Failed to validate JWT");
    test:prepare(gateway)
        .whenResource("polls")
        .onMethod("get")
        .withArguments("")
        .thenReturn(returnValue);

    var response = gateway->/polls(jwt = "");
    test:assertTrue(response is error);
    test:assertExactEquals(response, returnValue);
}

@test:Config
public function testGetUsersWithMultipleJsonObjects() returns error? {
    GatewayClientStub gateway = test:mock(GatewayClientStub);

    json[] returnValue = [{"name": "user1"}, {"name": "user2"}];
    test:prepare(gateway)
        .whenResource("users")
        .onMethod("get")
        .withArguments("validJwt")
        .thenReturn(returnValue);

    var response = gateway->/users(jwt = "validJwt");

    test:assertTrue(response is json[]);
    test:assertExactEquals(response, returnValue);
}

@test:Config
public function testGetPollsWithMultipleJsonObjects() returns error? {
    GatewayClientStub gateway = test:mock(GatewayClientStub);

    json[] returnValue = [{"id": "poll1"}, {"id": "poll2"}];
    test:prepare(gateway)
        .whenResource("polls")
        .onMethod("get")
        .withArguments("validJwt")
        .thenReturn(returnValue);

    var response = gateway->/polls(jwt = "validJwt");

    test:assertTrue(response is json[]);
    test:assertExactEquals(response, returnValue);
}
