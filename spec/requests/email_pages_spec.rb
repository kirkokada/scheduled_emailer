require 'rails_helper'
require 'support/factory_girl'

RSpec.describe "Email Pages", type: :feature do
  subject { page }

  describe "new" do
    
    before { visit new_email_path }

    describe "page" do

      it { should have_selector "h1", text: "New Email" }
      it { should have_selector "input#email_to" }
      it { should have_selector "input#email_subject" }
      it { should have_selector "textarea#email_body" }
      it { should have_button   "Schedule Email" }
      
      it "should have year, month, day, hour, and minute selectors" do
        5.times do |n|
          n += 1
          expect(page).to have_selector "select#email_deliver_at_#{n}i"
        end
      end
    end

    context "with invalid information" do
      before do
        fill_in "To", with: "not_an_email_address"
        select "2010", from: "email_deliver_at_1i"
      end

      it "should not create a scheduled email" do
        expect do 
          click_button "Schedule Email" 
        end.not_to change(Email, :count)
      end

      context "after submitting the form" do
        before { click_button "Schedule Email" }

        it "should render email#new" do
          expect(page).to have_selector "h1", text: "New Email"
        end

        it { should have_selector "div#error_messages" }
      end
    end

    context "with valid information" do
      let(:subject_text) { "Test Email Subject" }
      before do
        fill_in "To", with: "testemail@gmail.com"
        fill_in "Subject", with: subject_text
        fill_in "Body", with: "Hello"
        select "2020", from: "email_deliver_at_1i"
      end
      
      it "should create a scheduled email" do
        expect do 
          click_button "Schedule Email" 
        end.to change(Email, :count)
      end

      context "after submitting the form" do
        before { click_button "Schedule Email" }

        it "should redirect to root" do
          expect(page).to have_selector "h1", text: "Scheduled Emails"
        end

        it "should list the scheduled email" do
          expect(page).to have_content subject_text
        end
      end
    end
  end
  
  describe "index" do

    let!(:first)  { create :email, subject: "First",   deliver_at: 1.day.from_now }
    let!(:second) { create :email, subject: "Second",  deliver_at: 2.days.from_now }
    let!(:third)  { create :email, subject: "Thrid",   deliver_at: 3.days.from_now }

    before { visit root_path }

    describe "page" do
      
      it { should have_selector "h1", text: "Scheduled Emails" }

      it { should have_link "New Email", new_email_path }

      it "should list the emails in order of scheduled delivery time" do
        expect(page).to have_selector "ul#email_list li:first-child",  text: first.subject
        expect(page).to have_selector "ul#email_list li:nth-child(2)", text: second.subject
        expect(page).to have_selector "ul#email_list li:nth-child(3)", text: third.subject
      end

      context "after an email is scheduled to be delivered" do
        
        before do 
          ActionMailer::Base.deliveries.clear
          first.update_column(:deliver_at, 1.day.ago)
          Email.send_scheduled_emails
          visit root_path
        end

        it "should have sent the email" do
          expect(ActionMailer::Base.deliveries.size).to eq 1
        end

        it { should_not have_content first.subject }
      end
    end
  end
end
