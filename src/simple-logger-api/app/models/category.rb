class Category < ApplicationRecord
  has_many :records, dependent: :destroy

  validates_presence_of :name
end
