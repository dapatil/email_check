require 'active_model'
require 'active_model/validations'
require 'email_check/email_address'
require 'pp'

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)

    unless value.present?
      add_error(record, attribute)
      return
    end

    address = EmailCheck::EmailAddress.new(value)

    unless address && address.format_valid?
      add_error(record, attribute)
      return
    end

    if options[:block_special_usernames] && address.blocked_username?
      add_error(record, attribute)
      return
    end

    return if address.whitelisted_domain?

    if options[:not_disposable] && address.disposable?
      add_error(record, attribute)
      return
    end

    if options[:not_blacklisted] && address.blacklisted_domain?
      add_error(record, attribute)
      return
    end

    if options[:not_free] && address.free_email_provider?
      add_error(record, attribute)
      return
    end

    # TODO: Add a callback to bypass this if the domain is already known
    if options[:check_mx] && address.domain_has_mx? == false
      add_error(record, attribute)
      return
    end
  end

  private
  def add_error(record, attribute)
    record.errors.add(attribute, options[:message] || :invalid)
  end
end