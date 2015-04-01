class Emailer < ApplicationMailer
  default from: "from@example.com"

  def regular(email)
    @email = email

    mail to: @email.to, subject: @email.subject
  end
end
