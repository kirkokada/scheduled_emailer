require 'rails_helper'

RSpec.describe Email, type: :model do
  it { should respond_to :to }
  it { should respond_to :subject }
  it { should respond_to :body }
  it { should respond_to :deliver_at }
end
