class Email < ActiveRecord::Base
  validate :deliver_at_is_valid_date_time
  validate :deliver_at_is_in_the_future
  validate :email_is_valid
  validates :to, presence: true

  def self.send_scheduled_emails
    current_time = DateTime.now
    scheduled_emails = Email.unsent.where("deliver_at < :now", now: current_time)
    scheduled_emails.each do |mail|
      Emailer.regular(mail).deliver_now
      mail.update_column(:sent, true)
    end
  end

  def self.unsent
    where("sent = false")
  end

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
