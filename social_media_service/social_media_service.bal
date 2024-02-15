import ballerina/http;
import ballerina/time;

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

table<User> key(id) usersTable = table [
    {id: 1, name: "Daniel", dateOfBirth: {year: 1990, month: 5, day: 12}, mobileNumber: "0771234567"}
];

service /social\-media on new http:Listener(9090) {
    resource function get users() returns User[]|error? {
        return usersTable.toArray();
    }

    resource function get users/[int id]() returns User|UserNotFound|error? {
        User? userResult = usersTable[id];
        if userResult !is User {
            return <UserNotFound>{
                body: {message: string `id: ${id}`, details: string `user/${id}`, timeStamp: time:utcNow()}
            };
        }

        return userResult;
    }
}
