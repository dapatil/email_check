require 'active_model'
require 'active_model/validations'
require 'email_check/email_address'

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    error(record, attribute) unless value.present?

    address = EmailCheck::EmailAddress.new(value)

    error(record, attribute) && return unless address.format_valid?

    return if address.whitelisted?

    if options[:disposable]
      error(record, attribute) && return if address.disposable?
    end

    if options[:blacklist]
      error(record, attribute) && return if address.blacklisted?
    end

    if options[:free]
      error(record, attribute) && return if address.free?
    end

    if options[:mx]
      error(record, attribute) && return unless address.domain_has_mx?
    end
  end

  private
  def error(record, attribute)
    record.errors.add(attribute, options[:message] || :invalid)
  end
end