import ballerina/http;
import ballerina/test;

http:Client gatewayClient = check new (string `http://localhost:${port}`);

@test:Config
public function testGetJwt() returns error? {
    http:Response response = check gatewayClient->/jwt.get();

    test:assertEquals(response.statusCode, http:STATUS_OK);
}

@test:Config
public function testGetUsersWithInvalidJwt() returns error? {
    gatewayClient = test:mock(http:Client);

    test:prepare(gatewayClient).when("get").withArguments("/users")
        .thenReturn("");

    string jwt = "invalid jwt";

    http:Response|error response = check gatewayClient->/users.get(params = {
        "jwt": jwt
    });

    test:assertTrue(response is error);
}

@test:Config
public function testGetUsersWithValidJwt() returns error? {
    http:Response response = check gatewayClient->/jwt.get();

    string jwt = check response.getTextPayload();

    response = check gatewayClient->/users.get(params = {
        "jwt": jwt
    });

    test:assertEquals(response.statusCode, http:STATUS_OK);
}

@test:Config
public function testGetPollsWithInvalidJwt() returns error? {
    string jwt = "invalid jwt";

    http:Response|error response = gatewayClient->/polls.get(params = {
        "jwt": jwt
    });

    test:assertTrue(response is error);
}

@test:Config
public function testGetPollsWithValidJwt() returns error? {
    http:Response response = check gatewayClient->/jwt.get();

    string jwt = check response.getTextPayload();

    response = check gatewayClient->/polls.get(params = {
        "jwt": jwt
    });

    test:assertEquals(response.statusCode, http:STATUS_OK);
}
