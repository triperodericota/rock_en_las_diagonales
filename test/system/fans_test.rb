require "application_system_test_case"

class FansTest < ApplicationSystemTestCase
  setup do
    @fan = fans(:one)
  end

  test "visiting the index" do
    visit fans_url
    assert_selector "h1", text: "fans"
  end

  test "creating a fans" do
    visit fans_url
    click_on "New fans"

    click_on "Create fans"

    assert_text "fans was successfully created"
    click_on "Back"
  end

  test "updating a fans" do
    visit fans_url
    click_on "Edit", match: :first

    click_on "Update fans"

    assert_text "fans was successfully updated"
    click_on "Back"
  end

  test "destroying a fans" do
    visit fans_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "fans was successfully destroyed"
  end
end
