module Weeler
  class StaticSectionsController < ContentController
    def show
      @section = params[:id]
      @items = Weeler.static_sections[@section.to_sym]
    end

    def update
      params[:translations].each do |translation|
        id, value = translation.first, translation.last
        translation = I18n::Backend::Weeler::Translation.find(id)
        translation.value = value
        translation.save
      end
      Weeler.cache_sync.write = Time.now.to_f
      redirect_to({action: :show, id: params[:id]}, {flash: {success: "Section updated."}})
    end
  end
end
