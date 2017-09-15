# EmailCheck

[![Gem Version][GV img]][Gem Version]
[![Build Status][BS img]][Build Status]
[![Dependency Status][DS img]][Dependency Status]
[![Code Climate][CC img]][Code Climate]
[![Coverage Status][CS img]][Coverage Status]

## Description
This was originally built for [Anonybuzz](https://anonybuzz.com) and is now used at [StarTalent](https://startalent.io). 
This gem provides a robust mechanism to validate email addresses and restrict account creation to corporate email accounts.

This gem also ships with a data-set of free and [disposable](http://en.wikipedia.org/wiki/Disposable_email_address)
email domains which are used for validation checks.

You can also block certain usernames from creating accounts. Examples: admin, root

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
gem "email_check"
```

## Usage
### Use with ActiveModel
To validate just the format of the email address
```ruby
class User < ActiveRecord::Base
  validates_email :email
end
```
To validate that the domain has a MX record:
```ruby
validates_email :email, check_mx: true
```
To validate that the email is not from a disposable or free email provider:
```ruby
validates_email :email, not_disposable:true, not_free:true
```
To validate that the domain is not blacklisted:
```ruby
validates_email :email, not_blacklisted:true
```

To validate that the username is not blocked
```ruby
validates_email :email, block_special_usernames:true
```

Everything together:
```ruby
validates_email :email,
    check_mx: true, 
    not_disposable:true, 
    not_free:true, 
    not_blacklisted:true,
    block_special_usernames:true,
    message: "Please register with your corporate email"
```

To turn everything on by default, you can use the validates_email_strictness helper. 
     
```ruby
# Example above
validates_email_strictness :email

# Everything but allow free emails. This is what most people would want to use
validates_email_strictness :email, not_free:false
```

### Modifying the inbuilt lists
The lists are exposed as assignable arrays so you can customize them or load whatever data you please.

Add a config/intializers/email_check.rb
```ruby
# Set disposable email domains
EmailCheck.disposable_email_domains = ['freemail.org']
# Append to the whitelist
EmailCheck.whitelisted_domains << 'gmail.com'
EmailCheck.free_email_domains << 'thenewgmail.com'
# Setting a domain in the blacklist will also blacklist all subdomains
EmailCheck.blacklisted_domains << 'lvh.me'
# Block the 'anonymous' username for all domains
EmailCheck.blocked_usernames << 'anonymous'
```

## Requirements
This gem is tested with Rails 4.0+. Ruby versions tested:
- Ruby 2.0
- Ruby 2.1
- Ruby 2.2
- Ruby 2.3

Rails versions tested:
Rails 4.0
Rails 5.0

## Credits
- This code is heavily based upon: [lisinge/valid_email2](https://github.com/lisinge/valid_email2) 
- Data is from: [lavab/disposable](https://github.com/lavab/disposable/blob/master/domains.txt) and
              [willwhite/freemail](https://github.com/willwhite/freemail/blob/master/data/free.txt)

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
