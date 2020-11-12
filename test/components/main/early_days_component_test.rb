require 'view_component/test_case'

module Main
  class EarlyDaysComponentTest < ViewComponent::TestCase
    def setup
      @state_translation = YAML::load(File.open("#{Rails.root}/config/app/state_translation.yaml"))
      @initial_states = YAML::load(File.open("#{Rails.root}/config/app/initial_states.yaml"))
    end

    def test_early_days_menu_card_setup
      render_inline(Main::Component.new(
        state_translation: @state_translation,
        initial_states: @initial_states,
        initial_state: @initial_states[:early_state]
      ))

      # Time to Start Cooking Menu card
      refute page.find('#base-setup-omakase').checked?
      refute page.find('#base-setup-api').checked?
      assert page.find('#base-setup-early').checked?
      refute page.find('#base-setup-minimalist').checked?

      # Our Database Menu Menu card
      assert page.find('#database-choice-SQLite').checked?
      refute page.find('#database-choice-Postgres').checked?
      refute page.find('#database-choice-MySQL').checked?

      # Guest Favorites Menu card
      refute page.find('#rails-flags-guest-favorites-spring').checked?
      refute page.find('#rails-flags-guest-favorites-listen').checked?
      refute page.find('#rails-flags-guest-favorites-bootsnap').checked?

      # Starters Menu card
      assert page.find('#rails-flags-starters-gemfile').checked?
      assert page.find('#rails-flags-starters-gitignore').checked?
      refute page.find('#rails-flags-starters-keep').checked?
      assert page.find('#rails-flags-starters-bundle').checked?
      assert page.find('#rails-flags-starters-puma').checked?

      # Mains Menu card
      refute page.find('#rails-flags-mains-actionText').checked?
      assert page.find('#rails-flags-mains-activeRecord').checked?
      refute page.find('#rails-flags-mains-activeStorage').checked?
      refute page.find('#rails-flags-mains-actionCable').checked?

      # Email me Maybe (#not) Menu card
      assert page.find('#rails-flags-email-actionMailer').checked?
      refute page.find('#rails-flags-email-actionMailbox').checked?

      # Le Frontend Menu card
      assert page.find('#rails-flags-frontend-sprockets').checked?
      refute page.find('#rails-flags-frontend-javascript').checked?
      refute page.find('#rails-flags-frontend-turbolinks').checked?
      refute page.find('#rails-flags-frontend-webpacker').checked?
      refute page.find('#rails-flags-frontend-yarn').checked?

      # Testing Menu card
      assert page.find('#rails-flags-testing-minitest').checked?
      refute page.find('#rails-flags-testing-system').checked?
    end
  end
end
