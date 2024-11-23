// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

import ballerina/jballerina.java;
import ballerina/persist;
import ballerina/sql;
import ballerinax/persist.sql as psql;
import ballerinax/postgresql;
import ballerinax/postgresql.driver as _;

const POLL = "polls";
const VOTE = "votes";
const USER = "users";

public isolated client class Client {
    *persist:AbstractPersistClient;

    private final postgresql:Client dbClient;

    private final map<psql:SQLClient> persistClients;

    private final record {|psql:SQLMetadata...;|} & readonly metadata = {
        [POLL]: {
            entityName: "Poll",
            tableName: "Poll",
            fieldMetadata: {
                id: {columnName: "id"},
                question: {columnName: "question"},
                userId: {columnName: "userId"},
                registrationTimestamp: {columnName: "registrationTimestamp"},
                "votes[].id": {relation: {entityName: "votes", refField: "id"}},
                "votes[].option": {relation: {entityName: "votes", refField: "option"}},
                "votes[].answers": {relation: {entityName: "votes", refField: "answers"}},
                "votes[].pollId": {relation: {entityName: "votes", refField: "pollId"}}
            },
            keyFields: ["id"],
            joinMetadata: {votes: {entity: Vote, fieldName: "votes", refTable: "Vote", refColumns: ["pollId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE}}
        },
        [VOTE]: {
            entityName: "Vote",
            tableName: "Vote",
            fieldMetadata: {
                id: {columnName: "id"},
                option: {columnName: "option"},
                answers: {columnName: "answers"},
                pollId: {columnName: "pollId"},
                "poll.id": {relation: {entityName: "poll", refField: "id"}},
                "poll.question": {relation: {entityName: "poll", refField: "question"}},
                "poll.userId": {relation: {entityName: "poll", refField: "userId"}},
                "poll.registrationTimestamp": {relation: {entityName: "poll", refField: "registrationTimestamp"}}
            },
            keyFields: ["id"],
            joinMetadata: {poll: {entity: Poll, fieldName: "poll", refTable: "Poll", refColumns: ["id"], joinColumns: ["pollId"], 'type: psql:ONE_TO_MANY}}
        },
        [USER]: {
            entityName: "User",
            tableName: "User",
            fieldMetadata: {
                id: {columnName: "id"},
                name: {columnName: "name"},
                email: {columnName: "email"},
                registeredObjects: {columnName: "registeredObjects"}
            },
            keyFields: ["id"]
        }
    };

    public isolated function init() returns persist:Error? {
        postgresql:Client|error dbClient = new (host = host, username = user, password = password, database = database, port = port, options = connectionOptions);
        if dbClient is error {
            return <persist:Error>error(dbClient.message());
        }
        self.dbClient = dbClient;
        self.persistClients = {
            [POLL]: check new (dbClient, self.metadata.get(POLL), psql:POSTGRESQL_SPECIFICS),
            [VOTE]: check new (dbClient, self.metadata.get(VOTE), psql:POSTGRESQL_SPECIFICS),
            [USER]: check new (dbClient, self.metadata.get(USER), psql:POSTGRESQL_SPECIFICS)
        };
    }

    isolated resource function get polls(PollTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get polls/[string id](PollTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post polls(PollInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(POLL);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from PollInsert inserted in data
            select inserted.id;
    }

    isolated resource function put polls/[string id](PollUpdate value) returns Poll|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(POLL);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/polls/[id].get();
    }

    isolated resource function delete polls/[string id]() returns Poll|persist:Error {
        Poll result = check self->/polls/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(POLL);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get votes(VoteTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get votes/[string id](VoteTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post votes(VoteInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(VOTE);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from VoteInsert inserted in data
            select inserted.id;
    }

    isolated resource function put votes/[string id](VoteUpdate value) returns Vote|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(VOTE);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/votes/[id].get();
    }

    isolated resource function delete votes/[string id]() returns Vote|persist:Error {
        Vote result = check self->/votes/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(VOTE);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get users(UserTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get users/[string id](UserTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post users(UserInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(USER);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from UserInsert inserted in data
            select inserted.id;
    }

    isolated resource function put users/[string id](UserUpdate value) returns User|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(USER);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/users/[id].get();
    }

    isolated resource function delete users/[string id]() returns User|persist:Error {
        User result = check self->/users/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(USER);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    remote isolated function queryNativeSQL(sql:ParameterizedQuery sqlQuery, typedesc<record {}> rowType = <>) returns stream<rowType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor"
    } external;

    remote isolated function executeNativeSQL(sql:ParameterizedQuery sqlQuery) returns psql:ExecutionResult|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor"
    } external;

    public isolated function close() returns persist:Error? {
        error? result = self.dbClient.close();
        if result is error {
            return <persist:Error>error(result.message());
        }
        return result;
    }
}

