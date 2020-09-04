class Record < ApplicationRecord
  belongs_to :creator
  belongs_to :category

  validates_presence_of :key
  validates_presence_of :value
  validates_presence_of :timestamp
end
