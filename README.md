# AwsOneClickStaging

AwsOneClickStaging is a CLI app that will allow you to create a clone of amazon's S3 bucket (named app_name-staging) and the RDS database (named app_name-staging) so your staging server will be 100% up to date with your production server and allow you to perform some serious testing without the fear of losing important files stored on your S3 bucket.  

If you didn't already know, S3 is a file storage solution offered by Amazon, and it's not user friendly so you pretty much need to write/ use a script like this in order to setup a staging server.  RDS is Amazon's database storage.  As with all amazon services, RDS databases are in the clown so you can rely on it working well with your app and working hard to provide your users with hillarious service.  


## Installation

Run this code (you need ruby) to install:

```ruby
$  gem install aws_one_click_staging
```

Next you'll need to setup the config file:

(~/.config/aws_one_click_staging.yml)
```
aws_access_key_id: ""
aws_secret_access_key: ""
aws_region: 'us-west-1'
aws_master_username: ""
aws_master_user_password: ""
aws_production_bucket: "" # this bucket is read from
aws_staging_bucket: ""    # this bucket is DELETED and written to!

db_instance_id_production: "actioncenter"           # this db_instance is read from
db_instance_id_staging: "actioncenter-staging"      # this db_instance is DELETED and written to!
db_snapshot_id: "actioncenter-snapshot-for-staging" # this db snapshot id is OVERWRITTEN
```


## Usage

Because amazon services are kind of a mess right now, it's best to run this from on an actual Amazon server you have shell access to (it downloads the bucket files and then re-uploads them, lol).

```
aws_one_click_staging stage
```

After a while, the operation will complete and it will say 'congrats' or something and output the RDS url and bucket name for the staging clone.  Plug those values into your staging server and you should be good to go.  


## AWS Permissions

Because you're a professional, you want to grant only the permissions absolutely necessary to the 'staging-bot' user.  
That's commendable.  Use the below scripts and replace `PRODUCTIONDB` with the name of your production database/ s3 bucket (hopefully you used the same name for both).  These rules are set via the `Identity & Access Management` subconsole on amazon.  

(staging-bot-rds-can-do-anything-to-staging-db)
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1448499769000",
            "Effect": "Allow",
            "Action": [
                "rds:*"
            ],
            "Resource": [
                "arn:aws:rds:*:*:db:PRODUCTIONDB-staging"
            ]
        }
    ]
}
```
(staging-bot-rds-can-do-anything-to-staging-snapshot)
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1448518052000",
            "Effect": "Allow",
            "Action": [
                "rds:*"
            ],
            "Resource": [
                "arn:aws:rds:*:*:snapshot:PRODUCTIONDB-snapshot-for-staging"
            ]
        }
    ]
}
```
(staging-bot-rds-can-snapshot-production-db)
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1448517746000",
            "Effect": "Allow",
            "Action": [
                "rds:CreateDBSnapshot"
            ],
            "Resource": [
                "arn:aws:rds:*:*:db:PRODUCTIONDB"
            ]
        }
    ]
}
```
(staging-bot-s3-can-do-anything-to-staging-bucket)
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1448518841000",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::PRODUCTIONDB-staging",
                "arn:aws:s3:::PRODUCTIONDB-staging/*"
            ]
        }
    ]
}
```
(staging-bot-s3-can-read-from-production-bucket)
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1448523618000",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketAcl",
                "s3:GetBucketCORS",
                "s3:GetBucketLocation",
                "s3:GetBucketLogging",
                "s3:GetBucketNotification",
                "s3:GetBucketPolicy",
                "s3:GetBucketRequestPayment",
                "s3:GetBucketTagging",
                "s3:GetBucketVersioning",
                "s3:GetBucketWebsite",
                "s3:GetLifecycleConfiguration",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:GetObjectTorrent",
                "s3:GetObjectVersion",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectVersionTorrent",
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:ListBucketVersions",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::PRODUCTIONDB",
                "arn:aws:s3:::PRODUCTIONDB/*"
            ]
        }
    ]
}
```


## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

There's a couple unit tests with commented out method calls.  This was how I tested against amazon, simply uncomment a line, drop in a `binding.pry;exit!` and test/ debug what ever methods you think are messing up.  


## Contributing

1. Fork it ( https://github.com/[my-github-username]/aws_one_click_staging/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
