require 'email_check'
require 'resolv'
require 'mail'

module EmailCheck
  class EmailAddress
    def initialize(email_address)
      @email_address = email_address.downcase
      @email = Mail::Address.new(@email_address) rescue nil
    end

    def format_valid?
      @format_valid ||= check_format()
    end

    def disposable?
      EmailCheck.disposable_email_domains.include?(@email.domain)
    end

    def free?
      EmailCheck.free_email_domains.include?(@email.domain)
    end

    def blacklisted?
      EmailCheck.blacklisted_domains.each do |domain|
        return true if @email.domain.include?(domain)
      end

      false
    end

    def whitelisted?
      EmailCheck.whitelisted_domains.include?(@email.domain)
    end

    def domain_has_mx?
      return false unless format_valid?

      Resolv::DNS.open do |dns|
        return dns.getresources(@email.domain, Resolv::DNS::Resource::IN::MX).any?
      end
    end

    private
    def check_format
      return false unless @email

      if @email.domain && @email.address == @email_address
        domain = @email.domain
        # Must have a ., Must not have consecutive .s
        domain.include?('.') && !domain.match(/\.{2,}/)
      else
        false
      end
    end
  end
end