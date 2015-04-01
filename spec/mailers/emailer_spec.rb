require "rails_helper"
require "support/factory_girl"

RSpec.describe Emailer, type: :mailer do
  describe "default" do
    let(:email) { create :email }
    let(:mail) { Emailer.regular(email) }

    it "renders the headers" do
      expect(mail.subject).to eq(email.subject)
      expect(mail.to).to eq([email.to])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(email.body)
    end
  end

end
