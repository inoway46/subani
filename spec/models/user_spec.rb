require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'バリデーション確認' do
    it 'emailが未入力のユーザーは作成できないこと' do
      user = User.new
      expect(user.valid?).to be false
      expect(user.errors[:email]).to include("を入力してください")
    end

    it '重複したemailのユーザーは作成できないこと' do
      duplicated_user = User.new(email: user.email)
      expect(duplicated_user.valid?).to be false
      expect(duplicated_user.errors[:email]).to include("はすでに存在します")
    end
  end
end
