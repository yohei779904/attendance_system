class AttendsController < ApplicationController
  before_action :logged_in_user, only: [:index]
  before_action :correct_user, only: [:edit, :update] # ユーザー自身のみが情報を編集・更新可能。

  def new
    @attend = Attend.new 
  end

  def index
    @first_day = Date.current.beginning_of_month
    @last_day = @first_day.end_of_month
    # 当月の月初から月末までを取得して、且つユーザーのIDを取得する。
    @attends = Attend.where(worked_day: @first_day..@last_day).where(user_id: current_user.id)
    @worked_sum = Attend.where.not(in: nil).count
  end
  
  def create
    @attend = Attend.find_by(worked_day: Date.today, user_id: current_user.id)
    if @attend.blank?
        @attend = Attend.build(worked_day: Date.today, user_id: current_user.id)
    end
      if params[:commit] == "出勤"
        @attend.in = Time.now

      elsif params[:commit] == "退勤"
        @attend.out = Time.now
      end


    if @attend.save!
      flash[:success] = '登録が完了しました'
      redirect_to current_user
    else
      flash.now[:danger] = '登録に失敗しました。'
      render 'users/show'
    end  
  end 

  private


  # 下記以降はbeforeアクション。


  # ログイン済みのユーザーか確認する。
  def logged_in_user
    unless logged_in?
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

  # アクセスしたユーザーが、現在ログインしているユーザーか確認する。
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end
end
