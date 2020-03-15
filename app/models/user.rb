class User < ApplicationRecord

	# 仮想の属性である「remember_token」を作成。
	# 最下部のメソッド「remember」で使用。
	attr_accessor :remember_token

  has_many :attends, dependent: :destroy

  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    # 下記でメールアドレスが一意であることを検証
                    uniqueness: { case_sensitive: false }

  validates :basic_time, presence: true
  
  has_secure_password
  # 下記で存在性（presence）と、最小文字数（6文字以上）を設定
  validates :password, presence: true, length: { minimum: 6 }
 

	# 下記以降は記憶トークン


  # 渡された文字列のハッシュ値を返す。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す。
  def User.new_token
    SecureRandom.urlsafe_base64
	end
		
	# 永続セッションのためハッシュ化したトークンをデータベースに記憶。
	def remember
		# 「User.new_token」でハッシュ化されたトークン情報を生成して「remember_token」に代入。
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# トークンがダイジェストと一致すればtrueを返す。
	def authenticated?(remember_token)
			# ダイジェストが存在しない場合はfalseを返して終了。
      return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	# ユーザーのログイン情報を破棄する。
	def forget
		update_attribute(:remember_digest, nil)
	end
end

