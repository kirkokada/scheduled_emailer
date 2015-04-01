class Email < ActiveRecord::Base
  validate :deliver_at_is_valid_date_time
  validate :deliver_at_is_in_the_future

  private

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
