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
aws_access_key_id: ''
aws_secret_access_key: ''
aws_region: 'us-west-1'
aws_bucket: ''
db_host: ''
db_port: '5432'
db_password: ''
```


## Usage

Because amazon services are kind of a mess right now, it's best to run this from on an actual Amazon server you have shell access to (it downloads the bucket files and then re-uploads them, lol).

```
aws_one_click_staging stage 
```

After a while, the operation will complete and it will say 'congrats' or something and output the RDS url and bucket name for the staging clone.  Plug those values into your staging server and you should be good to go.  


## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/aws_one_click_staging/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
