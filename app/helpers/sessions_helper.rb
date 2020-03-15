module SessionsHelper

    # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
    def current_user
      if session[:user_id]
        @current_user ||= User.find_by(id: session[:user_id])
      end
    end
  
    # 永続的セッションを記憶。ログインするユーザーはブラウザで有効な記憶トークンを取得できるよう記録される。
    def remember(user)
      user.remember
      cookies.permanent.signed[:user_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token
    end
  
  # 下記2つのアクションで永続的セッションを終了しつつログアウトする。
  
    # 永続的セッションを破棄する。
    def forget(user)
      user.forget
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
    end
  
    # セッションと@current_userを破棄する。
    def log_out
      forget(current_user)
      session.delete(:user_id)
      @current_user = nil
    end
  
     # 渡されたユーザーがログイン済みのユーザーであればtrueを返す。
     def current_user?(user)
      user == current_user
    end
  
    # 現在ログイン中のユーザーがいればtrue（ログイン状態）、そうでなければfalse（ログアウト状態）を返す。
    def logged_in?
      !current_user.nil?
    end
  
    # 記憶しているURL(またはデフォルトURL)にリダイレクトする。
    def redirect_back_or(default_url)
      redirect_to(session[:forwarding_url] || default_url)
      # 上記アクション直後に『session.delete(:forwarding_url)』で一時的セッションを破棄する。
      # 記憶したURLを削除しておかないと、次回ログインした時にも記憶されているURLへ転送されてしまうため。
      session.delete(:forwarding_url) 
    end
  
    # アクセスしようとしたURLを記憶する。
    def store_location
      # 『request.original_url』で記憶したいURLを取得することができる。
      # 『request.get?』を条件式に指定することで、GETリクエストのみを記憶する。
      session[:forwarding_url] = request.original_url if request.get?
    end
  end