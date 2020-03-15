class UsersController < ApplicationController
    before_action :set_one_month, only: [:show,]
    before_action :set_user, only: [:show, :edit, :update]
    before_action :logged_in_user, only: [:show, :edit, :update]
    before_action :correct_user, only: [:edit, :update] # ユーザー自身のみが情報を編集・更新可能。
  
    def show
    end
  
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
  
      if @user.save
        flash[:success] = 'ユーザを登録しました。'
        redirect_to @user
      else
        flash.now[:danger] = 'ユーザの登録に失敗しました。'
        render :new
      end  
    end 
  
    def edit
    end
  
    def update
  
      # update_attributesメソッドでデータベースの値を複数同時に更新する。
      if @user.update_attributes(user_params)
        flash[:success] = "ユーザー情報を更新しました。"
        redirect_to @user
      else
        render :edit      
      end
    end
  
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
    # paramsハッシュからユーザーを取得する。
    def set_user
      @user = User.find(params[:id])
    end
  
  
    # 下記以降はbeforeアクション。
  
    
    # ログイン済みのユーザーか確認する。
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
  
     # アクセスしたユーザーが、現在ログインしているユーザーか確認する。
     def correct_user
      redirect_to(root_url) unless current_user?(@user)
    end
  end
  
