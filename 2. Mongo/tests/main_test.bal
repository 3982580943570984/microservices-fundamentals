import ballerina/http;
import ballerina/io;
import ballerina/test;

http:Client testClient = check new ("http://localhost:8080");

@test:Config
public function testAdditionOf100Elements() returns error? {
    foreach int _ in 1 ... 100 {
        Poll poll = {
            question: "",
            votes: []
        };

        http:Response response = check testClient->/polls.post(poll);

        test:assertEquals(response.statusCode, http:STATUS_CREATED);

        io:println(string `Created PollEntry: ${check response.getTextPayload()}`);
    }
}

@test:Config
public function testAdditionOf100000Elements() returns error? {
    foreach int _ in 1 ... 100000 {
        Poll poll = {
            question: "",
            votes: []
        };

        http:Response response = check testClient->/polls.post(poll);

        test:assertEquals(response.statusCode, http:STATUS_CREATED);

        io:println(string `Created PollEntry: ${check response.getTextPayload()}`);
    }
}

@test:Config
public function testDeletionOfAllElements() returns error? {
    PollEntry[] pollEntries = check testClient->/polls.get();

    foreach PollEntry pollEntry in pollEntries {
        http:Response response = check testClient->delete(string `/polls/${pollEntry.id}`);

        test:assertEquals(response.statusCode, http:STATUS_OK);
        test:assertEquals(response.getTextPayload(), pollEntry.id);

        io:println(string `Deleted PollEntry with id: ${pollEntry.id}`);
    }
}
