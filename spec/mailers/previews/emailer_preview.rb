# Preview all emails at http://localhost:3000/rails/mailers/emailer
class EmailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/emailer/regular
  def regular
    email = Email.first
    Emailer.regular(email)
  end

end
