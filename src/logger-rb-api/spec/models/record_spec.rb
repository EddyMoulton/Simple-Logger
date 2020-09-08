require 'rails_helper'

RSpec.describe Record, type: :model do
  it { should validate_presence_of(:key) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:timestamp) }
  it { should belong_to(:creator) }
  it { should belong_to(:category) }
end
