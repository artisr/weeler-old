require 'i18n'
require 'i18n/humanize_missing_translations'
require 'i18n/backend/weeler'

I18n.exception_handler.extend I18n::HumanizeMissingTranslations
I18n.backend = I18n::Backend::Chain.new(I18n::Backend::Weeler.new, I18n::Backend::Simple.new)