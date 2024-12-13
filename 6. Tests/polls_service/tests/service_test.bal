import ballerina/test;

@test:Config
public function testGetPolls() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    Poll[] polls = [
        {
            id: "1",
            question: "Question 1",
            userId: "user1",
            registrationTimestamp: "2024-01-01T12:00:00Z"
        },
        {
            id: "2",
            question: "Question 2",
            userId: "user2",
            registrationTimestamp: "2024-01-01T13:00:00Z"
        }
    ];

    test:prepare(databaseClient)
        .whenResource("polls")
        .onMethod("get")
        .thenReturn(polls);

    PollsClientStub pollsClient = new ();

    pollsClient.databaseClient = databaseClient;

    var response = pollsClient->/polls();

    test:assertTrue(response is Poll[]);
    test:assertExactEquals(response, polls);
}

@test:Config
public function testGetPollById() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    Poll poll = {
        id: "1",
        question: "Question 1",
        userId: "user1",
        registrationTimestamp: "2024-01-01T12:00:00Z"
    };

    test:prepare(databaseClient)
        .whenResource("polls/:id")
        .onMethod("get")
        .withPathParameters({id: "1"})
        .thenReturn(poll);

    PollsClientStub pollsClient = new ();

    pollsClient.databaseClient = databaseClient;

    var response = pollsClient->/polls/["1"]();

    test:assertTrue(response is Poll);
    test:assertExactEquals(response, poll);
}

@test:Config
public function testGetPollByIdNotFound() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    var mockError = error("Poll not found");

    test:prepare(databaseClient)
        .whenResource("polls/:id")
        .onMethod("get")
        .withPathParameters({id: "1"})
        .thenReturn(mockError);

    PollsClientStub pollsClient = new ();
    pollsClient.databaseClient = databaseClient;

    var response = pollsClient->/polls/["1"];

    test:assertTrue(response is error);
    test:assertExactEquals(response, mockError);
}

@test:Config
public function testPostPolls() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    PollInsert[] insertPolls = [
        {
            id: "1",
            question: "Question 1",
            userId: "user1",
            registrationTimestamp: "2024-01-01T12:00:00Z"
        },
        {
            id: "2",
            question: "Question 2",
            userId: "user2",
            registrationTimestamp: "2024-01-01T13:00:00Z"
        }
    ];

    string[] generatedIds = ["1", "2"];

    test:prepare(databaseClient)
        .whenResource("polls")
        .onMethod("post")
        .withArguments(insertPolls)
        .thenReturn(generatedIds);

    PollsClientStub pollsClient = new ();
    pollsClient.databaseClient = databaseClient;

    var response = pollsClient->/polls.post(insertPolls);

    test:assertTrue(response is string[]);
    test:assertExactEquals(response, generatedIds);
}

@test:Config
public function testPostPollsError() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    PollInsert[] insertPolls = [
        {
            id: "1",
            question: "Question 1",
            userId: "user1",
            registrationTimestamp: "2024-01-01T12:00:00Z"
        },
        {
            id: "2",
            question: "Question 2",
            userId: "user2",
            registrationTimestamp: "2024-01-01T13:00:00Z"
        }
    ];

    var mockError = error("Failed to add polls");

    test:prepare(databaseClient)
        .whenResource("polls")
        .onMethod("post")
        .withArguments(insertPolls)
        .thenReturn(mockError);

    PollsClientStub pollsClient = new ();
    pollsClient.databaseClient = databaseClient;

    var response = pollsClient->/polls.post(insertPolls);

    test:assertTrue(response is error);
    test:assertExactEquals(response, mockError);
}

@test:Config
public function testPutPoll() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    PollUpdate updatePoll = {
        question: "Updated Question"
    };

    Poll updatedPoll = {
        id: "1",
        question: "Updated Question",
        userId: "user1",
        registrationTimestamp: "2024-01-01T12:00:00Z"
    };

    test:prepare(databaseClient)
        .whenResource("polls/:id")
        .onMethod("put")
        .withPathParameters({id: "1"})
        .withArguments(updatePoll)
        .thenReturn(updatedPoll);

    PollsClientStub pollsClient = new ();
    pollsClient.databaseClient = databaseClient;

    var response = pollsClient->/polls/["1"].put(updatePoll);

    test:assertTrue(response is Poll);
    test:assertExactEquals(response, updatedPoll);
}

@test:Config
public function testPutPollError() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    PollUpdate updatePoll = {question: "Updated Question"};
    var mockError = error("Failed to update poll");

    test:prepare(databaseClient)
        .whenResource("polls/:id")
        .onMethod("put")
        .withPathParameters({id: "1"})
        .withArguments(updatePoll)
        .thenReturn(mockError);

    PollsClientStub pollsClient = new ();
    pollsClient.databaseClient = databaseClient;
    var response = pollsClient->/polls/["1"].put(updatePoll);

    test:assertTrue(response is error);
    test:assertExactEquals(response, mockError);
}

@test:Config
public function testDeletePoll() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    Poll deletedPoll = {
        id: "1",
        question: "Question",
        userId: "user1",
        registrationTimestamp: "2024-01-01T12:00:00Z"
    };

    test:prepare(databaseClient)
        .whenResource("polls/:id")
        .onMethod("delete")
        .withPathParameters({id: "1"})
        .thenReturn(deletedPoll);

    PollsClientStub pollsClient = new ();

    pollsClient.databaseClient = databaseClient;

    var response = pollsClient->/polls/["1"].delete();

    test:assertTrue(response is Poll);
    test:assertExactEquals(response, deletedPoll);
}

@test:Config
public function testDeletePollError() returns error? {
    DatabaseClientStub databaseClient = test:mock(DatabaseClientStub);

    var mockError = error("Failed to delete poll");

    test:prepare(databaseClient)
        .whenResource("polls/:id")
        .onMethod("delete")
        .withPathParameters({id: "1"})
        .thenReturn(mockError);

    PollsClientStub pollsClient = new ();
    pollsClient.databaseClient = databaseClient;
    var response = pollsClient->/polls/["1"].delete();

    test:assertTrue(response is error);
    test:assertExactEquals(response, mockError);
}
