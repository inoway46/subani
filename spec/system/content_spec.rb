require 'rails_helper'

RSpec.describe 'Content', type: :system do
  let(:user) { create(:user) }
  let(:content) { create(:content) }

  describe 'Content一覧' do
    context '正常系' do
      it 'Contentが表示されること' do; end
    end
  end

  describe 'Content新規作成' do
    context '正常系' do
      it 'Contentが新規作成されること' do; end
    end

    context '異常系' do
      it 'selectが未選択の場合、Contentが新規作成されないこと' do; end
    end
  end

  describe 'Content詳細' do
    context '正常系' do
      it 'Contentが表示されること' do; end
    end
  end

  describe 'Content更新' do
    context '正常系' do
      it 'Contentが更新されること' do; end
    end

    context '異常系' do
      it 'titleが未入力の場合、Contentが更新されないこと' do; end
    end
  end

  describe 'Content削除' do
    context '正常系' do
      it 'Contentが削除されること' do; end
    end
  end
end
