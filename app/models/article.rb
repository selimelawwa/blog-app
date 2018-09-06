class Article < ApplicationRecord
	belongs_to :user
  	validates :content, :title, :user_id, presence: true
  	has_many :favorites, dependent: :destroy
  	has_many :fans, through: :favorites, source: :user
end
