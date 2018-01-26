module Weeler
  module ActionView
    module Helpers
      module TranslationHelper
        extend ActiveSupport::Concern

        def translate(key, options = {})
          request.present? && request.params[:show_translation_keys] == "true" ? "<a href='/root/translations?query=#{key}'>#{key}</a>".html_safe : super(key, options)
        end
        alias :t :translate

      end
    end
  end
end
