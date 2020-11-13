module Main
  module MenuCard
    module Checkbox
      class Component < ViewComponent::Base
        def initialize(menu_card_id:, title:, subtitle:, items:, menu_card_in_all_states:, menu_card_in_a_specific_state:, card_state_translation:)
          @menu_card_id                  = menu_card_id
          @title                         = title
          @subtitle                      = subtitle
          @items                         = items
          @menu_card_in_all_states       = menu_card_in_all_states
          @menu_card_in_a_specific_state = menu_card_in_a_specific_state
          @card_state_translation        = card_state_translation

          update_items
        end

        private

        def update_items
          @menu_card_in_a_specific_state.each do |item_name, checked|
            item_to_update_for(item_name).merge!(
              {
                command_output: command_output_for(item_name),
                checked: checked,
                html_data_attributes: html_data_attributes_for(item_name),
                html_id: html_id_for(item_name)
              }
            )
          end
        end

        def item_to_update_for(item_name)
          @items.find { |item| item[:title] =~ /#{item_name}/i }
        end

        def command_output_for(item_name)
          @card_state_translation[item_name][false]
        end

        def html_data_attributes_for(item_name)
          HTMLDataAttributeGenerator.new(item_name, @menu_card_in_all_states, @menu_card_id).html_data_attributes
        end

        def html_id_for(item_name)
          "rails-flags-#{@menu_card_id}-#{item_name}".downcase.dasherize
        end
      end

      class HTMLDataAttributeGenerator
        def initialize(item_name, menu_card_in_all_states, menu_card_id)
          @item_name = item_name
          @menu_card_in_all_states = menu_card_in_all_states
          @menu_card_id = menu_card_id
        end

        def html_data_attributes
          @menu_card_in_all_states[@item_name].each_with_object([]) do |(base_state_name, base_state_value), html_data_attributes|
            html_data_attributes << html_data_attribute(base_state_name, base_state_value)
          end.join(' ').html_safe
        end

        private

        def html_data_attribute(base_state_name, base_state_value)
          attribute_code = <<-CODE
            #{attribute_name(base_state_name)}="#{base_state_value}"
          CODE

          attribute_code.squish.tr(' ', '')
        end

        def attribute_name(base_state_name)
          "data-#{base_state_name}".downcase.dasherize
        end
      end
    end
  end
end
