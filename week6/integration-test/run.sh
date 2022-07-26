#!/usr/bin/env bash

cd "$(dirname "$0")"

export AWS_ACCESS_KEY_ID=foobar
export AWS_SECRET_ACCESS_KEY=foobar

export INPUT_FILE_PATTERN="s3://nyc-duration/in/{year:04d}-{month:02d}.parquet"
export OUTPUT_FILE_PATTERN="s3://nyc-duration/out/{year:04d}-{month:02d}.parquet"

export S3_ENDPOINT_URL="http://localhost:4566"

docker-compose up -d

sleep 1

aws --endpoint-url=http://localhost:4566 \
    s3 mb s3://nyc-duration

pipenv run python integration_test.py

cd ..

pipenv run python batch.py 2021 1

FILE="result_2021_1.parquet"
aws --endpoint-url=${S3_ENDPOINT_URL} s3 cp s3://nyc-duration/out/2021-01.parquet ./${FILE}

ls

if [ ! -f "$FILE" ]; then
    docker-compose logs
    docker-compose down
    exit 1
fi

rm ./${FILE}

cd -
docker-compose down
