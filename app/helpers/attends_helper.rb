module AttendsHelper

  # 00:00 形式の時間を返す
  def time_str(time)
    time ? time.strftime('%H:%M') : ''
  end

end