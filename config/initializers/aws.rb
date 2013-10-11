# These are AWS default values. They are not suitable for production but they will can be used
# in development for quick setup. For a more stable configuration setup your application.yml file.

module AWS
  Key = ENV["AWS_ACCESS_KEY_ID"].nil? ? "AKIAJVA4G5ZOQ2I2DW4A" : ENV["AWS_ACCESS_KEY_ID"]
  Secret = ENV["AWS_SECRET_ACCESS_KEY"].nil? ? "qld/sGifLU3cUEmX6w0W5+8YwNmzsDACaBELXH0d" : ENV["AWS_SECRET_ACCESS_KEY"]
  Region = ENV["AWS_DEFAULT_REGION"].nil? ? "us-east-1" : ENV["AWS_S3_PUBLIC_BUCKET"]
  PublicBucket = ENV["AWS_S3_PUBLIC_BUCKET"].nil? ? "snappea-default" : ENV["AWS_S3_PUBLIC_BUCKET"]
  PrivateBucket = ENV["AWS_S3_PRIVATE_BUCKET"].nil? ? "snappea-default" : ENV["AWS_S3_PRIVATE_BUCKET"]
  PrivateWindow = ENV["AWS_S3_PRIVATE_WINDOW"].nil? ? 86400 : ENV["AWS_S3_PRIVATE_WINDOW"]
end

