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
        create(:master)
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

      it 'Contentを登録フォームから追加できること' do
        click_on 'Abema'
        expect(page).to have_selector 'h5', text: 'Abemaビデオ'
        expect(page).to have_content master.title
        find(:id, "content_master_id_2").check
        click_on '登録する'
        expect(page).to have_content master.title
      end
    end
  end
end
