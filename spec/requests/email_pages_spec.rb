require 'rails_helper'
require 'support/factory_girl'

RSpec.describe "Email Pages", type: :feature do
  subject { page }
  
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
    end
  end
end
