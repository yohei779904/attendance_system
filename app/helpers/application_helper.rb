module ApplicationHelper

    # ページ名とアプリケーション名を区切る記号の『|』を非表示にする。
    def full_title(page_name = "")
      base_title = "勤怠管理システム"
      if page_name.empty?
        base_title
      else
        page_name + " | " + base_title
      end
    end
  end
