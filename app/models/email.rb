class Email < ActiveRecord::Base
  validate :deliver_at_is_valid_date_time
  validate :deliver_at_is_in_the_future
  validate :email_is_valid
  validates :to, presence: true

  private

    def email_is_valid
      mg = Mailgun::Client.new(ENV['mailgun_api_key'])
      res = mg.get("address/validate", { address: to }).to_h
      errors.add(:to, "must be a valid email address") unless res["is_valid"]
    end

    def deliver_at_is_valid_date_time
      if ((DateTime.parse(deliver_at.to_s) rescue ArgumentError) == ArgumentError)
        errors.add(:deliver_at, 'must be a valid datetime')
      end
    end

    def deliver_at_is_in_the_future
      if DateTime.now > DateTime.parse(deliver_at.to_s)
        errors.add(:deliver_at, "must be a future datetime")
      end
    end
end
