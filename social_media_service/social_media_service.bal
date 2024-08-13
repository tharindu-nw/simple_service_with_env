import ballerina/http;
import ballerina/os;
import ballerina/time;

import social_media_service.log_handler;

type User record {|
    readonly int id;
    string name;
    time:Date dateOfBirth;
    string mobileNumber;
|};

type ErrorDetails record {
    string message;
    string details;
    time:Utc timeStamp;
};

type UserNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};

final readonly & table<User> key(id) usersTable = table [
    {id: 1, name: "Daniel", dateOfBirth: {year: 1990, month: 5, day: 12}, mobileNumber: "0771234567"}
];

configurable string logSuffix = ?;

service /social\-media on new http:Listener(9090) {
    isolated resource function get users() returns User[]|error? {
        return usersTable.toArray();
    }

    isolated resource function get users/[int id]() returns User|UserNotFound|error? {
        User? userResult = usersTable[id];
        log_handler:logMessage(string `User with id ${id} requested. ${logSuffix}`);
        if userResult !is User {
            return <UserNotFound>{
                body: {message: string `id: ${id}`, details: string `user/${id}`, timeStamp: time:utcNow()}
            };
        }

        return userResult;
    }

    isolated resource function get env() returns json {
        return {
            value_1: os:getEnv("VALUE_1"),
            value_2: os:getEnv("VALUE_2"),
            value_3: os:getEnv("VALUE_3")
        };
    }
}
