# S3 Sync Script

This script synchronizes a local directory with an S3 bucket, excluding specified files and directories, and applies a lifecycle policy to transition objects to long-term storage.

## Prerequisites

- **AWS CLI**: Ensure that the AWS CLI is installed and configured with the necessary permissions.
   - Installation: [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
   - Configuration: `aws configure`

## Setup

1. Create the .env file: Define the necessary environment variables in a .env file. Ensure this file is added to .gitignore to exclude it from version control.

```
# .env

DEFAULT_LOCAL_DIR=/path/to/default/local/directory
S3_BUCKET=s3://your-bucket-name
EXCLUSIONS_FILE=/path/to/your/exclusions.txt
```

2. Create the Exclusions File: Define the files and directories to exclude in the EXCLUSIONS_FILE.

```
# exclusions.txt

node_modules/*
tests/*
temp/*
*.log
```

3. Make the Script Executable

```.sh
chmod +x sync.sh
```

## Run the script

```
# Using default local directory
./sync.sh

# Passing a local directory
./sync.sh /path/to/your/local/directory
```
