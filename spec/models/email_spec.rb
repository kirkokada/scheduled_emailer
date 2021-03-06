require 'rails_helper'

RSpec.describe Email, type: :model do
  subject { Email.new(to: "user@email.com", deliver_at: 3.days.from_now) }

  it { should respond_to :to }
  it { should respond_to :subject }
  it { should respond_to :body }
  it { should respond_to :deliver_at }
  it { should respond_to :sent }

  context "when deliver_at" do
    
    describe "is not a datetime" do

      before { subject.deliver_at = "March 2011"}

      it { should_not be_valid }
    end

    describe "is not a future datetime" do

      before { subject.deliver_at = 3.hours.ago }

      it { should_not be_valid }
    end

    describe "is a future datetime" do

      before { subject.deliver_at = 3.hours.from_now }

      it { should be_valid }
    end
  end

  context "when to" do
    
    describe "is nil" do
      
      before { subject.to = nil }

      it { should_not be_valid }
    end

    describe "is blank" do
      
      before { subject.to = " " }

      it { should_not be_valid }
    end

    describe "is not a valid email" do
      
      before { subject.to = "not@nemail,crom" }

      it { should_not be_valid }
    end
  end
end
