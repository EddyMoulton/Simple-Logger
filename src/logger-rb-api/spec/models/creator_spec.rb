require 'rails_helper'

RSpec.describe Creator, type: :model do
  it { should validate_presence_of(:name) }
  it { should have_many(:records).dependent(:destroy) }
end
