class User < ApplicationRecord
    include SessionsHelper

    has_secure_password
    before_save   :downcase_email

    has_many :articles, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :favorite_articles, through: :favorites, source: :article
    has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
    has_many :passive_relationships, class_name:  "Relationship",
                                     foreign_key: "followed_id",
                                     dependent:   :destroy
    has_many :following, through: :active_relationships, source: :followed                                
    has_many :followers, through: :passive_relationships, source: :follower

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                          format: { with: VALID_EMAIL_REGEX },
                        uniqueness: { case_sensitive: false }

	  validates :name,  presence: true, length: { maximum: 50 }
  	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    

    attr_accessor :remember_token

    def remember
	    self.remember_token = new_token
	    update_attribute(:remember_digest, digest(remember_token))
    end

  	def forget
    	update_attribute(:remember_digest, nil)
  	end

  	# Returns true if the given token matches the digest.
  	def authenticated?(remember_token)
	    digest = send("remember_digest")
	    return false if digest.nil?
	    BCrypt::Password.new(digest).is_password?(remember_token)
  	end

    def favorite(article)
      if !self.favors?(article)
        Favorite.create(user_id: self.id, article_id: article.id)
      end
    end

    def unfavorite(article)
      if self.favors?(article)
        Favorite.find_by(user_id: self.id, article_id: article.id).destroy
      end
    end

    def favors?(article)
      !self.favorite_articles.find_by(id: article.id).nil?
    end

      # Follows a user.
    def follow(other_user)
      following << other_user
    end

    # Unfollows a user.
    def unfollow(other_user)
      following.delete(other_user)
    end

    # Returns true if the current user is following the other user.
    def following?(other_user)
      following.exists?(other_user.id)
    end

    def feed
      Article.where(user_id: following.ids <<  self.id)
    end


	private
	    # Converts email to all lower-case.
	    def downcase_email
	      self.email = email.downcase
	    end

end
