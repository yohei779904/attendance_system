class SessionsController < ApplicationController
  def new
    # sessionモデルが無いので無記入でOK！
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    if login(email, password)
      flash[:success] = 'ログインに成功しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render :new
    end
  end

  def destroy
    log_out if logged_in? # cookieに保存されたユーザーidを削除し、ログアウトを行う。
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end

  
  private

  def login(email, password)
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password) # authenticateメソッドでパスワードの一致を検証
      session[:user_id] = @user.id # ユーザーのブラウザ内にある一時的cookiesに暗号化済みのuser.idが自動で生成される。
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
        redirect_back_or user
        return true
      else
        return false
      end
    end
  end

end