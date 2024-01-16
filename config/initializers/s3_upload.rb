require 'aws-sdk-s3'

Aws.config.update(
  region: ENV['BUCKETEER_AWS_REGION'] || ENV['AWS_REGION'],
  credentials: Aws::Credentials.new(
    ENV['BUCKETEER_AWS_ACCESS_KEY_ID'] || ENV['AWS_ACCESS_KEY_ID'],
    ENV['BUCKETEER_AWS_SECRET_ACCESS_KEY'] || ENV['AWS_SECRET_ACCESS_KEY']
  )
)

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['BUCKETEER_BUCKET_NAME'] || ENV['AWS_S3_BUCKET'])
