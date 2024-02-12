import ballerina/http;
import ballerina/os;

service /sample on new http:Listener(9090) {
    resource function get value() returns string {
        return "Secret value:" + os:getEnv("SECRET_VALUE") + "\n";
    }
}

