# ilegraArchTestArch

## How to run?

1. Launch a jenkins on docker

2. Add the following SSH key to be able to checkout the repository:

shhhhh

3. Add two credentials (username and password) to Jenkins: AWS_ACCESS_KEY_ID (access key) and AWS_SECRET_KEY (secret key)

4. Use the "packerBaker.Jenkinsfile" and "terraformRunner.Jenkinsfile" to build the two pipelines.

Disclaimer:

- The first job will build an AMI on your AWS console.

- The second job will create 28 elements within the AWS environment according to the diagrams
