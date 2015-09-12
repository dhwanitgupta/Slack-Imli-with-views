class Channel < ActiveRecord::Base
  
  has_and_belongs_to_many :users
  
  validates :title, presence: true, length: {maximum: 50}, uniqueness: { case_sensitive: false }

end
