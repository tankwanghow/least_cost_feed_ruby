class Ingredient < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :cost, :status
  validates_uniqueness_of :name, scope: [:user_id, :batch_no]

  def self.find_ingredients terms=nil, page=1
    if terms.blank?
      User.current.ingredients.page(page).order(:name, :batch_no)
    else
      User.current.ingredients.where("name || batch_no || status || note ilike ?", "%#{terms}%").order(:name, :batch_no).page(page)
    end
  end
end
