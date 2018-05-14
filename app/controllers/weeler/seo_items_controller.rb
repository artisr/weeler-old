module Weeler
  class SeoItemsController < ConfigurationController

    def index
      @translations_in_seo = I18n::Backend::Weeler::Translation.select("key").where("key LIKE ?", "seo.%").order("key")
      @groups = @translations_in_seo.map{ |t| t.key.split(".")[1] }.uniq{ |t| t}
    end

    def edit
      @section = params[:id]
    end

    def update
      params[:translations].each do |key, value|
        translation = I18n::Backend::Weeler::Translation.find(key)
        translation.value = value
        translation.save
      end
      Weeler.cache_sync.write Time.now.to_f
      redirect_to({action: :edit, id: params[:id]}, {flash: {success: "Section updated."}})
    end
  end
end
