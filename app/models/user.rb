class User < ApplicationRecord

    has_many :articles, dependent: :destroy

    has_many :favorites, dependent: :destroy
    has_many :favorite_articles, through: :favorites, source: :article

	  validates :name,  presence: true, length: { maximum: 50 }
  	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    has_secure_password
    before_save   :downcase_email

    attr_accessor :remember_token

    def User.digest(string)
	    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                  BCrypt::Engine.cost
	    BCrypt::Password.create(string, cost: cost)
  	end

    def User.new_token
    	SecureRandom.urlsafe_base64
    end

    def remember
	    self.remember_token = User.new_token
	    update_attribute(:remember_digest, User.digest(remember_token))
    end

  	def forget
    	update_attribute(:remember_digest, nil)
  	end

  	# Returns true if the given token matches the digest.
  	def authenticated?(remember_token)
	    digest = send("#remember_digest")
	    return false if digest.nil?
	    BCrypt::Password.new(digest).is_password?(remember_token)
  	end

    def favorite(article)
      if self.favorite_articles.find_by(id: article.id).nil?
        Favorite.create(user_id: self.id, article_id: article.id)
      end
    end

    def unfavorite(article)
      if !self.favorite_articles.find_by(id: article.id).nil?
        Favorite.find_by(user_id: self.id, article_id: article.id).destroy
      end
    end

    def favors?(article)
      !self.favorite_articles.find_by(id: article.id).nil?
    end


	private
	    # Converts email to all lower-case.
	    def downcase_email
	      self.email = email.downcase
	    end

end
