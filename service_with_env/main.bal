import ballerina/http;
import ballerina/os;
import ballerina/log;

configurable string backendUrl = "http://localhost:9091/backend";
final http:Client backendClient = check new (backendUrl);

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

