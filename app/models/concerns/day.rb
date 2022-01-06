module Day
  extend ActiveSupport::Concern

  included do
    def day_of_week
      Date.today.strftime("%a")
    end

    def first_day?
      Date.today.day == 1
    end
  end
end