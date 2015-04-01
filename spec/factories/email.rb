FactoryGirl.define do
  factory :email do
    to "email@test.com"
    subject "Subject"
    body "Body"
    deliver_at 1.hour.from_now
  end
end