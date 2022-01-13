class ContentDecorator < Draper::Decorator
  delegate_all

  def media_color
    case self.media
    when "Abemaビデオ"
      "abema"
    when "Amazonプライム"
      "amazon"
    when "Netflix"
      "netflix"
    end
  end
end
