import ballerina/log;

configurable string logPrefix = ?;
public isolated function logMessage(string message) {
    log:printInfo(string `${logPrefix}: ${message}`);
}
