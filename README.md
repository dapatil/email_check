# EmailCheck

[![Gem Version][GV img]][Gem Version]
[![Build Status][BS img]][Build Status]
[![Dependency Status][DS img]][Dependency Status]
[![Code Climate][CC img]][Code Climate]
[![Coverage Status][CS img]][Coverage Status]

## Description
This was built for [Anonybuzz](https://anonybuzz.com). 
This gem provides a robust mechanism to validate email addresses and restrict account creation to corporate email accounts.

This gem also ships with a data-set of free and [disposable](http://en.wikipedia.org/wiki/Disposable_email_address)
email domains which are used for validation checks.

### Validation mechanisms
- Uses the mail gem. 
- Checks the domain's MX record
- Validate against a blacklist of domains
- Validates against a list of free email providers
- Validates against a list of disposable email providers
- A whitelist can be used to override these checks

## Installation
Add this line to your application's Gemfile:
```ruby
gem "check_email"
```

## Usage
### Use with ActiveModel
To validate just the email address:
```ruby
class User < ActiveRecord::Base
  validates :email, email: true
end
```
To validate that the domain has a MX record:
```ruby
validates :email, email: { mx: true }
```
To validate that the email is not from a disposable or free email provider:
```ruby
validates :email, email: { disposable:true, free:true }
```
To validate that the domain is not blacklisted:
```ruby
validates :email, email: { blacklist:true}
```
Everything together:
```ruby
validates :email, email: { mx: true, disposable:true, free:true, blacklist:true}
```

## Requirements
This gem is tested with Rails 4.0. Ruby versions tested:
- Ruby 2.0
- Ruby 2.1
- Ruby 2.2

[Gem Version]: https://rubygems.org/gems/email_check
[Build Status]: https://travis-ci.org/dapatil/email_check
[travis pull requests]: https://travis-ci.org/dapatil/email_check/pull_requests
[Dependency Status]: https://gemnasium.com/dapatil/email_check
[Code Climate]: https://codeclimate.com/github/dapatil/email_check
[Coverage Status]: https://coveralls.io/r/dapatil/email_check

[GV img]: https://badge.fury.io/rb/email_check.png
[BS img]: https://travis-ci.org/dapatil/email_check.png
[DS img]: https://gemnasium.com/dapatil/email_check.png
[CC img]: https://codeclimate.com/github/dapatil/email_check.png
[CS img]: https://coveralls.io/repos/dapatil/email_check/badge.png?branch=master


## Contributing

1. Fork it ( https://github.com/dapatil/email_check/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
