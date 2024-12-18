require "application_system_test_case"

class SystemModulesTest < ApplicationSystemTestCase
  setup do
    @system_module = system_modules(:one)
  end

  test "visiting the index" do
    visit system_modules_url
    assert_selector "h1", text: "System modules"
  end

  test "should create system module" do
    visit system_modules_url
    click_on "New system module"

    fill_in "Department", with: @system_module.department_id
    fill_in "Icon", with: @system_module.icon
    fill_in "Module url", with: @system_module.module_url
    fill_in "Name", with: @system_module.name
    click_on "Create System module"

    assert_text "System module was successfully created"
    click_on "Back"
  end

  test "should update System module" do
    visit system_module_url(@system_module)
    click_on "Edit this system module", match: :first

    fill_in "Department", with: @system_module.department_id
    fill_in "Icon", with: @system_module.icon
    fill_in "Module url", with: @system_module.module_url
    fill_in "Name", with: @system_module.name
    click_on "Update System module"

    assert_text "System module was successfully updated"
    click_on "Back"
  end

  test "should destroy System module" do
    visit system_module_url(@system_module)
    click_on "Destroy this system module", match: :first

    assert_text "System module was successfully destroyed"
  end
end
