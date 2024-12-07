import ballerina/http;
import ballerina/log;
import ballerina/test;

http:Client pollsClient = check new (string `http://localhost:${port}`);

@test:Config
public function testGetPolls() returns error? {
    http:Response|error response = pollsClient->/polls.get();
    test:assertTrue(response is http:Response);

    var httpResponse = check response.ensureType(http:Response);

    log:printDebug(check httpResponse.getTextPayload());
}
