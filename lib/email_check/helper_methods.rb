module ActiveModel
  module Validations
    module HelperMethods
      # Validates email
      #
      # Configuration options:
      # * <tt>:check_mx</tt> - Check MX record for domain
      # * <tt>:not_disposable</tt> - Check that this is not a disposable email
      # * <tt>:not_free</tt> - Not a free email (ex. gmail.com, hotmail.com)
      # * <tt>:not_blacklisted</tt> -  If domain is on the blacklist, reject it
      # * <tt>:block_special_usernames</tt> - If the username is one of the special usernames, reject it
      def validates_email(*attr_names)
        validates_with EmailValidator, _merge_attributes(attr_names)
      end

      # Turn everything on..
      def validates_corp_email(*attr_names)
        validates_with EmailValidator, _merge_attributes(attr_names).merge(
                                         :check_mx => true,
                                         :not_disposable => true,
                                         :not_free => true,
                                         :not_blacklisted => true,
                                         :block_special_usernames => true)
      end
    end
  end
end
