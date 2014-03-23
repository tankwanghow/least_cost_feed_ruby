class Nutrient < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :unit, :user
  validates_uniqueness_of :name

  def self.find_nutrients terms=nil, page=1
    if terms.blank?
      User.current.nutrients.page(page).order(:name)
    else
      User.current.nutrients.where("name || unit || note ilike ?", "%#{terms}%").order(:name).page(page)
    end
  end

end
