module Day
  extend ActiveSupport::Concern
  included do
    def day_of_week
      Date.today.strftime("%a")
    end

    def first_day?
      Date.today.day == 1
    end

    def this_month
      Date.today.month
    end

    def last_month
      Date.today.last_month.strftime("%m月")
    end

    def today_jp
      %w[日 月 火 水 木 金 土][Date.today.wday]
    end

    def yesterday
      Date.yesterday.strftime("%Y年 %m月 %d日")
    end
  end
end