class Article < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true
  
  has_many :favorites, dependent: :destroy

  has_many :fans, through: :favorites, source: :user

end
