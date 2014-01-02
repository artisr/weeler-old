module Weeler
  module Sluger
    extend ActiveSupport::Concern
    
    included do
      after_save :set_slug
    end

    def set_slug
      I18n.available_locales.each do |locale|
        Globalize.with_locale(locale) do
          if self.slug != generate_slug
            self.slug = generate_slug
            self.save!
          end
        end
      end
    end

    def generate_slug
      transliterated = "-#{I18n.transliterate(self.title).parameterize}" if self.title.present?
      transliterated = "" if transliterated.blank?
      "#{self.id}#{transliterated}"
    end

  end
end