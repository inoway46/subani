require 'rails_helper'

RSpec.describe 'Content', type: :system do
  let(:user) { create(:user) }
  let(:master) { create(:master) }
  let(:content) { create(:content) }

  describe 'Content一覧' do
    context '正常系' do
      before do
        visit new_user_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログイン"
      end

      it 'Contentが表示されること' do
        expect(page).to have_content content.title
      end

      it 'Contentを削除できること' do
        expect(page).to have_content content.title
        delete_button = find(".fa-trash-alt")
        delete_button.click
        expect(page).not_to have_content content.title
      end
    end
  end
end
