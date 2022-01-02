module Day
  extend ActiveSupport::Concern

  included do
    def day_of_week
      Date.today.strftime("%a")
    end
  end
end