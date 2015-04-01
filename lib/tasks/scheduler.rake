desc "Heroku scheduler tasks"

task send_scheduled_emails: :environment do
  puts "Sending scheduled emails"
  Email.send_scheduled_emails
  puts "Emails sent!"
end