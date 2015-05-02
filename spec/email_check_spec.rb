require 'spec_helper'

class TestEmail < TestModel
  validates :email, email: true
end

class TestBlacklistedEmail < TestModel
  validates :email, email: { not_blacklisted: true }
end

class TestDisposableEmail < TestModel
  validates :email, email: { not_disposable: true}
end

class TestFreeEmail < TestModel
  validates :email, email: { not_free: true}
end

class TestWhitelistedEmail < TestModel
  validates :email, email: true
end

class TestBlockedUsernameEmail < TestModel
  validates :email, email: { block_special_usernames: true }
end

class TestMxEmail < TestModel
  validates :email, email: { check_mx: true }
end

class TestValidationHelper < TestModel
  validates_email :email, :alternate_email, not_blacklisted: false
end

class TestStrictValidationHelper < TestModel
  validates_corp_email :email
end

describe EmailCheck do
  it 'has a version number' do
    expect(EmailCheck::VERSION).not_to be nil
  end

  describe "Basic validation" do
    it "should be invalid when email is empty" do
      expect(TestEmail.new(email:"").valid?).to be false
    end

    it "should be invalid when domain is missing" do
      ["dap", "dap@", "@"].each do |email|
        expect(TestEmail.new(email:email).valid?).to be false
      end
    end

    it "should be invalid if Mail::AddressListsParser raises exception" do
      t = TestEmail.new(email:"email@gmail.com")
      allow(Mail::Address).to receive(:new).and_raise(Mail::Field::ParseError.new(nil, nil, nil))
      expect(t.valid?).to be false
    end

    it "should be invalid when email is malformed" do
      ["foo@bar", "@bar", "foo@bar..com", "foo@bar."].each do |email|
        expect(TestEmail.new(email:email).valid?).to be false
      end
    end
  end

  describe "Disposable Emails" do
    before do
      EmailCheck.disposable_email_domains = []
    end

    it "should be valid when email domain is not in the list of disposable emails" do
      email = "user@gmail.com"
      expect(TestDisposableEmail.new(email:email).valid?).to be true
    end

    it "should not be valid when email domain is in the list of disposable emails" do
      EmailCheck.disposable_email_domains << "gmail.com"
      email = "user@gmail.com"
      expect(TestDisposableEmail.new(email:email).valid?).to be false
    end
  end

  describe "Free Emails" do
    before do
      EmailCheck.free_email_domains = []
    end

    it "should be valid when email domain is not in the list of free emails" do
      email = "someone@example.com"
      expect(TestFreeEmail.new(email:email).valid?).to be true
    end

    it "should not be valid when email domain is in the list of free emails" do
      EmailCheck.free_email_domains << "gmail.com"
      email = "someone@gmail.com"
      expect(TestFreeEmail.new(email:email).valid?).to be false
    end
  end

  describe "Blacklisted Emails" do
    before do
      EmailCheck.blacklisted_domains = []
    end
    it "should be valid when email domain is not in the list of blacklisted emails" do
      email = "someone@example.com"
      expect(TestBlacklistedEmail.new(email:email).valid?).to be true
    end

    it "should not be valid when email domain/subdomain is in the list of blacklisted domains" do
      EmailCheck.blacklisted_domains << "gmail.com"
      expect(TestBlacklistedEmail.new(email:"user@gmail.com").valid?).to be false
      expect(TestBlacklistedEmail.new(email:"user@sub.gmail.com").valid?).to be false
    end
  end

  describe "Whitelisted Emails" do
    before do
      EmailCheck.blacklisted_domains = ["gmail.com"]
      EmailCheck.free_email_domains = ["gmail.com"]
      EmailCheck.disposable_email_domains = ["gmail.com"]
      EmailCheck.whitelisted_domains = ["gmail.com"]
    end

    it "should be valid when domain is on whitelist and on all other lists" do
      expect(TestWhitelistedEmail.new(email:"user@gmail.com").valid?).to be true
    end
  end

  describe "MX check" do
    it "should be valid if valid MX records are found" do
      expect(TestMxEmail.new(email:"foo@gmail.com").valid?).to be true
    end

    it "should be invalid if no MX records are found" do
      expect(TestMxEmail.new(email:"foo@shit.example.com").valid?).to be false
    end
  end

  describe "Blocked Usernames" do
    it "should be valid if username is not blocked" do
      EmailCheck.blocked_usernames = []
      expect(TestBlockedUsernameEmail.new(email:"example@example.com").valid?).to be true
    end

    it "should be invalid if username is on blocked_usernames list" do
      EmailCheck.blocked_usernames << "example"
      expect(TestBlockedUsernameEmail.new(email:"example@example.com").valid?).to be false
    end
  end

  describe "Data loading" do
    it "should load the blacklist" do
      expect(EmailCheck.blacklisted_domains.length).to be > 0
    end

    it "should load free email domains" do
      expect(EmailCheck.free_email_domains.length).to be > 0
    end

    it "should load disposable email domains" do
      expect(EmailCheck.disposable_email_domains.length).to be > 0
    end

    it "should load blocked usernames" do
      expect(EmailCheck.blocked_usernames.length).to be > 0
    end
  end

  describe "Validation Helper" do
    it "should work with multiple fields" do
      EmailCheck.blacklisted_domains << "example.com"
      expect(TestValidationHelper.new(email:"foo@mart.io", alternate_email:"bar@example.com").valid?).to be true
      EmailCheck.blocked_usernames << "root"
      expect(TestStrictValidationHelper.new(email:"root@mart.io").valid?).to be false
    end
  end
end
