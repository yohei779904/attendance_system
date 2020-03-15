class ApplicationController < ActionController::Base
  # ここで定義したメソッドは、どのコントローラでも使えるようになる。

  protect_from_forgery with: :exception
  # 下記の記述で、SessionHelperで定義したメソッドを、どのコントローラでも使えるようになる。
  include SessionsHelper
  
  # ページ出力前に1ヶ月分のデータの存在を確認・セット。
  def set_one_month 
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 1ヶ月分の日時を代入。

    # ユーザーに紐付く一ヶ月分のレコードを検索し取得。
    @attendances = current_user.attends.where(worked_day: @first_day..@last_day).order(:worked_day)

    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか確認。
      ActiveRecord::Base.transaction do # トランザクションを開始。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成する。
        one_month.each { |day| current_user.attends.create!(worked_day: day) }
      end
      @attendances = current_user.attends.where(worked_day: @first_day..@last_day).order(:worked_day)
    end

    rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐。
      flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
      redirect_to root_url
  end

  private
  
  
end
