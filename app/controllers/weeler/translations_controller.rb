module Weeler
  class TranslationsController < ConfigurationController

    def index
      @translations = translations_by_params
      @translations = @translations.page(params[:page]).per(20)
      @groups = I18n::Backend::Weeler::Translation.groups
    end

    def new
      @translation = I18n::Backend::Weeler::Translation.new
    end

    def edit
      @translation = I18n::Backend::Weeler::Translation.find(params[:id])
    end

    def create
      @translation = I18n::Backend::Weeler::Translation.new(translation_params)

      if @translation.save
        Weeler.cache_sync.write Time.now.to_f
        redirect_to ({ action: :edit, id: @translation }), flash: { success: "Translation saved." }
      else
        flash.now[:error] = "Errors in saving."
        render :edit
      end
    end

    def update
      @translation = I18n::Backend::Weeler::Translation.find(params[:id])

      if @translation.update_attributes(translation_params)
        Weeler.cache_sync.write Time.now.to_f
        redirect_to ({ action: :edit, id: @translation }), flash: { success: "Translation updated." }
      else
        flash.now[:error] = "Errors in updating."
        render :edit
      end
    end

    def destroy
      @translation = I18n::Backend::Weeler::Translation.find(params[:id])
      @translation.destroy

      Weeler.cache_sync.write Time.now.to_f

      redirect_to ({ action: :index }), flash: {success: "Translation succesfully removed."}
    end

    def usage_stats
      @used_keys = []
      if Settings.log_key_usage == 'dump'
        I18n::Backend::Weeler::TranslationStat.all.each do |translation_stat|
          @used_keys << [translation_stat.key, translation_stat.usage_count]
        end
      else
        Weeler.i18n_cache.instance_variable_get(:@data).keys.each do |key|
          @used_keys << [key, Weeler.i18n_cache.read(key)] if key.start_with?('usage_stats')
        end
      end
    end

    def export
      respond_to do |format|
        format.xlsx do
          outstrio = StringIO.new
          outstrio.write(translations_by_params.as_xlsx_package.to_stream.read)
          send_data(outstrio.string, filename: "translations" + '.xlsx')
        end
      end
    end

    def import
      if params[:file].present?
        I18n::Backend::Weeler::Translation.import params[:file]

        Weeler.cache_sync.write Time.now.to_f

        redirect_to ({ action: :index }), flash: {success: "Translations succesfully imported."}
      else
        redirect_to ({ action: :index }), flash: {success: "No file choosen"}
      end
    end

  private

    def translation_params
      params.require(:i18n_backend_weeler_translation).permit([:locale, :key, :value, :is_proc, :interpolations => []])
    end

    def translations_by_params
      translations = I18n::Backend::Weeler::Translation.order("locale, key")

      translations = translations.where(locale: I18n.available_locales)

      translations = translations.where("created_at >= ?", Time.zone.parse(params[:date_from]).beginning_of_day) if params[:date_from].present?
      translations = translations.where("created_at <= ?", Time.zone.parse(params[:date_till]).end_of_day) if params[:date_till].present?

      ::Weeler.excluded_i18n_groups.each do |key|
        translations = translations.except_key(key)
      end

      translations = translations.where("key ILIKE ? OR value ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%") if params[:query]
      translations = translations.where(locale: params[:filtered_locale]) if params[:filtered_locale].present?

      translations = translations.lookup(params[:group]) if params[:group].present?
      translations
    end

  end
end
