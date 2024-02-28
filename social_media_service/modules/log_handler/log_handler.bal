import ballerina/log;

configurable string logPrefix = ?;
public function logMessage(string message) {
    log:printInfo(string `${logPrefix}: ${message}`);
}
