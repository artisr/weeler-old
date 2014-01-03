require 'spec_helper'

describe Weeler::TranslationsController do

  before do
    routes.draw do
      mount_weeler_at "/weeler"
    end
  end

  describe "GET #index" do
    before do
      FactoryGirl.create(:translation, key: 'foo.bar')
      FactoryGirl.create(:translation, key: 'bar.foo')
    end

    it "list translations" do
      get :index
      expect(assigns(:translations).size).to eq(2)
    end
  end

  describe "#create" do
    it "creates translation in DB" do
      expect(I18n.t("title", locale: :en)).to eq("Title")
      I18n::Backend::Weeler::Translation.delete_all

      post :create, i18n_backend_weeler_translation: FactoryGirl.attributes_for(:translation)

      expect(I18n.t("title", locale: :en)).to eq("This is weeler")
    end
  end

  describe "#update" do
  end

  describe "#destroy" do
  end

  describe "#import" do
  end

  describe "#export" do
  end

end