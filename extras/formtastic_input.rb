#
# Code snippet to create a formtastic input
# You can use this code in your custom formbuilder
#
# Usage: form.input :name, :as => :person_name
#

module Formtastic
  module PersonName
    def person_name_input(method, options)
      html_options         = options.delete(:input_html) || {}
      html_options         = default_string_options(method, :person_name).merge(html_options)
      html_options[:class] = [html_options[:class], "person-name"].compact.join(" ")

      part_fields          = PersonName::NameSplitter::NAME_PARTS.collect do |field_part|
        self.hidden_field("#{method}_#{field_part}")
      end.join.html_safe

      self.label(method, options_for_label(options)) <<
          content_tag(:p, self.text_field(method, html_options) << part_fields, :class => "field-group")
    end
  end
end
