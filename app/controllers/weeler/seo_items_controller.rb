module Weeler
  class SeoItemsController < ConfigurationController

    def index
      @translations_in_seo = I18n::Backend::Weeler::Translation.select("key").where("key LIKE ?", "seo.%").order("key")
      @groups = @translations_in_seo.map{ |t| t.key.split(".")[1...-1].join('_') }.uniq{ |t| t}
    end

    def edit
      @section = params[:id].gsub('_', '.')
    end

    def update
      params[:translations].each do |translation|
        id, value = translation.first, translation.last
        translation = I18n::Backend::Weeler::Translation.find(id)
        translation.value = value
        translation.save
      end
      Settings.i18n_updated_at = Time.now
      redirect_to({action: :edit, id: params[:id]}, {flash: {success: "Section updated."}})
    end
  end
end
