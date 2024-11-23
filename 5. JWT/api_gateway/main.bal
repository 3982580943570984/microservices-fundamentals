import ballerina/http;
import ballerina/jwt;

configurable int port = ?;

configurable string usersHost = ?;
configurable int usersPort = ?;

configurable string pollsHost = ?;
configurable int pollsPort = ?;

service on new http:Listener(port) {
    private final http:Client usersClient;
    private final http:Client pollsClient;

    private final jwt:IssuerConfig issuerConfig;
    private final jwt:ValidatorConfig validatorConfig;

    public function init() returns error? {
        self.usersClient = check new (string `${usersHost}:${usersPort}`);

        self.pollsClient = check new (string `${pollsHost}:${pollsPort}`);

        self.issuerConfig = {
            signatureConfig: {
                config: {
                    keyFile: "./resources/private.key"
                }
            }
        };

        self.validatorConfig = {
            signatureConfig: {
                certFile: "./resources/public.crt"
            }
        };
    }

    resource function get jwt() returns string|error? {
        return check jwt:issue(self.issuerConfig);
    }

    resource function get users(string jwt) returns json[]|error? {
        jwt:Payload _ = check jwt:validate(jwt, self.validatorConfig);
        return check self.usersClient->/users;
    }

    resource function get polls(string jwt) returns json[]|error? {
        jwt:Payload _ = check jwt:validate(jwt, self.validatorConfig);
        return check self.pollsClient->/polls;
    }
}

