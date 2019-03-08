## Testing RabbitMQ Deployments with Newman

### Variables Needed
Variable Name | Variable Value
------------- | ---------------
APIURL | The URL to test against. *ex*: **api.example.com**
AuthToken | The Authorization Token to connect to the API *ex*: **hf8f3n3F3fg2d**


### Testing Locally

The easiest way to run these tests is to leverage the official [Newman Docker Image](https://hub.docker.com/r/postman/newman) from Postman Labs.

Follow these steps:

Pull down the Docker container for Newman (** Note: this is only needed prior to the first run on local machine, and only speeds up Step 3**):
 ``` console
docker pull postman/newman
```

Clone the API Repository ( ** Note: this is only required if you do not have a copy of the repository on your machine. **):
 ``` console
git clone git@github.com:ndlib/api.git
```

Run the Newman collection against the desired RabbitMQ server:

 ``` console
docker run -v /full/path/to/api/spec/newman:/etc/newman -t postman/newman run API.postman_collection.json --global-var "APIURL=Value" --global-var "AuthToken=value"
```
