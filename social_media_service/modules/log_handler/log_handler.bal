import ballerina/log;
import ballerina/os;

// configurable string logPrefix = ?;
public function logMessage(string message) {
    log:printInfo(string `${os:getEnv("LOG_PREFIX")}: ${message}`);
}
