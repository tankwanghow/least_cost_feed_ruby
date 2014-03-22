class Nutrient < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :unit, :user
  validates_uniqueness_of :name
end
