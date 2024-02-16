import ballerina/http;
import ballerina/os;
import ballerina/log;

final http:Client backendClient = check new (os:getEnv("ServiceURL"),
    auth = {
        tokenUrl: os:getEnv("TokenURL"),
        clientId: os:getEnv("ConsumerKey"),
        clientSecret: os:getEnv("ConsumerSecret")
    }
);

service /sample on new http:Listener(9090) {
    resource function get value() returns string|error {
        do {
            http:Response res = check backendClient->/users/[1]();
            json payload = check res.getJsonPayload();
            return "Secret value:" + os:getEnv("SECRET_VALUE") + "\n" +
                "User Name: " + (check payload.name).toString() + "\n";
        } on fail error e {
            log:printError("API ", e);
            return e;
        }
    }
}

