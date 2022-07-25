export AWS_ACCESS_KEY_ID=foobar
export AWS_SECRET_ACCESS_KEY=foobar

aws --endpoint-url=http://localhost:4566 s3 mb s3://nyc-duration
aws --endpoint-url=http://localhost:4566 s3 ls
aws --endpoint-url=http://localhost:4566 s3 ls --summarize --recursive s3://nyc-duration