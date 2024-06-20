#!/bin/bash

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found."
    exit 1
fi

# Check if required variables are set in the .env file
if [ -z "$DEFAULT_LOCAL_DIR" ]; then
    echo "Error: DEFAULT_LOCAL_DIR is not set in the .env file."
    exit 1
fi

if [ -z "$S3_BUCKET" ]; then
    echo "Error: S3_BUCKET is not set in the .env file."
    exit 1
fi

if [ -z "$EXCLUSIONS_FILE" ]; then
    echo "Error: EXCLUSIONS_FILE is not set in the .env file."
    exit 1
fi

usage() {
    echo "Usage: $0 [local_directory]"
    echo "If no local_directory is provided, the default directory will be used."
    exit 1
}

if [ -z "$1" ]; then
    LOCAL_DIR=$DEFAULT_LOCAL_DIR
else
    LOCAL_DIR=$1
fi

DIR_NAME=$(realpath "$LOCAL_DIR")

if [ ! -d "$LOCAL_DIR" ]; then
    echo "Error: Directory $LOCAL_DIR does not exist."
    exit 1
fi

if [ ! -f "$EXCLUSIONS_FILE" ]; then
    echo "Error: Exclusions file $EXCLUSIONS_FILE does not exist."
    exit 1
fi

EXCLUDE_PARAMS=""
while IFS= read -r pattern
do
    # Skip empty lines and lines containing only whitespace
    if [[ -n "$pattern" && ! "$pattern" =~ ^[[:space:]]*$ ]]; then
        EXCLUDE_PARAMS+=" --exclude \"$pattern\""
    fi
done < "$EXCLUSIONS_FILE"

DESTINATION_PATH=$S3_BUCKET$DIR_NAME

eval "aws s3 sync \"$LOCAL_DIR\" \"$S3_BUCKET$DIR_NAME\" $EXCLUDE_PARAMS --exact-timestamps"
