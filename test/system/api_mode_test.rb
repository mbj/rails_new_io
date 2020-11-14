require 'application_system_test_case'

class APIModeTest < ApplicationSystemTestCase

  test 'Switching from "Omakase" to "API Mode" works correctly' do
    visit root_path

    find('#base-setup-api').click

    # Time to Start Cooking Menu card
    refute page.find('#base-setup-omakase').checked?
    assert page.find('#base-setup-api').checked?
    refute page.find('#base-setup-early').checked?
    refute page.find('#base-setup-minimalist').checked?

    # Our Database Menu Menu card
    assert page.find('#database-choice-sqlite').checked?
    refute page.find('#database-choice-postgres').checked?
    refute page.find('#database-choice-mysql').checked?

    # Guest Favorites Menu card
    assert page.find('#rails-flags-guest-favorites-spring').checked?
    assert page.find('#rails-flags-guest-favorites-listen').checked?
    assert page.find('#rails-flags-guest-favorites-bootsnap').checked?

    # Starters Menu card
    assert page.find('#rails-flags-starters-gemfile').checked?
    assert page.find('#rails-flags-starters-gitignore').checked?
    assert page.find('#rails-flags-starters-keep').checked?
    assert page.find('#rails-flags-starters-bundle').checked?
    assert page.find('#rails-flags-starters-puma').checked?

    # Mains Menu card
    assert page.find('#rails-flags-mains-actiontext').checked?
    assert page.find('#rails-flags-mains-activerecord').checked?
    assert page.find('#rails-flags-mains-activestorage').checked?
    assert page.find('#rails-flags-mains-actioncable').checked?

    # Email me Maybe (#not) Menu card
    assert page.find('#rails-flags-email-actionmailer').checked?
    assert page.find('#rails-flags-email-actionmailbox').checked?

    # Le Frontend Menu card
    assert page.find('#rails-flags-frontend-sprockets').checked?
    assert page.find('#rails-flags-frontend-javascript').checked?
    assert page.find('#rails-flags-frontend-turbolinks').checked?
    assert page.find('#rails-flags-frontend-webpacker').checked?
    assert page.find('#rails-flags-frontend-yarn').checked?

    # Testing Menu card
    assert page.find('#rails-flags-testing-minitest').checked?
    assert page.find('#rails-flags-testing-system').checked?

    command_line_output = find(:xpath, "//p[@id='rails-new-output-text']").text

    assert_equal command_line_output.squish, 'rails new my_app --api'
  end

  test 'Switching from "The Early Days" to "API Mode" works correctly' do
    visit root_path

    find('#base-setup-early').click
    find('#base-setup-api').click

    command_line_output = find(:xpath, "//p[@id='rails-new-output-text']").text

    assert_equal command_line_output.squish, 'rails new my_app --api'
  end

  test 'Switching from "API Mode" to "The Minimalist" works correctly' do
    visit root_path

    find('#base-setup-api').click
    find('#base-setup-minimalist').click

    command_line_output = find(:xpath, "//p[@id='rails-new-output-text']").text

    assert_equal command_line_output.squish, 'rails new my_app --skip-action-cable --skip-action-mailbox --skip-action-mailer --skip-action-text --skip-active-storage --skip-bootsnap --skip-bundle --skip-gemfile --skip-git --skip-javascript --skip-keeps --skip-listen --skip-puma --skip-spring --skip-sprockets --skip-system-test --skip-test --skip-turbolinks --skip-webpack-install --skip-yarn'
  end

  private

  def choose_card_item(html_id:)
    find("##{html_id}").click
  end
end
