# props to bantic
# https://gist.github.com/bantic/4080793
require 'aws/s3' # gem name is 'aws-sdk'

class BucketSyncService
  attr_reader :from_bucket, :to_bucket, :logger
  attr_accessor :debug

  DEFAULT_ACL = :public_read

  # from_credentials and to_credentials are both hashes with these keys:
  #  * :aws_access_key_id
  #  * :aws_secret_access_key
  #  * :bucket
  def initialize(from_credentials, to_credentials)
    @from_bucket = bucket_from_credentials(from_credentials)
    @to_bucket   = bucket_from_credentials(to_credentials)
  end

  def perform(output=STDOUT)
    object_counts = {sync:0, skip:0}
    create_logger(output)

    logger.info "Starting sync."
    from_bucket.objects.each do |object|
      if object_needs_syncing?(object)
        sync(object)
        object_counts[:sync] += 1
      else
        logger.debug "Skipped #{pp object}"
        object_counts[:skip] += 1
      end
    end
    logger.info "Done. Synced #{object_counts[:sync]}, " +
      "skipped #{object_counts[:skip]}."
  end

  private

  def create_logger(output)
    @logger = Logger.new(output).tap do |l|
      l.level = debug ? Logger::DEBUG : Logger::INFO
    end
  end

  def sync(object)
    logger.debug "Syncing #{pp object}"
    object.copy_to( to_bucket.objects[object.key], acl:DEFAULT_ACL)
  end

  def pp(object)
    content_length_in_kb = object.content_length / 1024
    "#{object.key} #{content_length_in_kb}k " +
      "#{object.last_modified.strftime("%b %d %Y %H:%M")}"
  end

  def object_needs_syncing?(object)
    to_object = to_bucket.objects[object.key]
    return true if !to_object.exists?

    return to_object.etag != object.etag
  end

  def bucket_from_credentials(credentials)
    s3 = AWS::S3.new(access_key_id:      credentials[:aws_access_key_id],
                     secret_access_key:  credentials[:aws_secret_access_key])

    bucket = s3.buckets[ credentials[:bucket] ]
    if !bucket.exists?
      bucket = s3.buckets.create( credentials[:bucket] )
    end
    bucket
  end
end



=begin
Example usage:
 from_creds = {aws_access_key_id:"XXX", aws_secret_access_key:"YYY", bucket:"first-bucket"}
 to_creds = {aws_access_key_id:"ZZZ", aws_secret_access_key:"AAA", bucket:"second-bucket"}
 syncer = BucketSyncService.new(from_creds, to_creds)
 syncer.debug = true # log each object
 syncer.perform
=end
