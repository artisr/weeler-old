class GlobalizeFormBuilder < ActionView::Helpers::FormBuilder
  def globalize_fields_for(locale, *args, &proc)
    raise ArgumentError, "Missing block" unless block_given?
    @index = @index ? @index + 1 : 1
    object_name = "#{@object_name}[translations_attributes][#{@index}]"
    object = @object.translations.find_by_locale locale.to_s
    @template.concat @template.hidden_field_tag("#{object_name}[id]", object ? object.id : "")
    @template.concat @template.hidden_field_tag("#{object_name}[locale]", locale)
    @template.concat @template.fields_for(object_name, object, *args, &proc)
  end
end