require "application_system_test_case"

class DepartmentModulesTest < ApplicationSystemTestCase
  setup do
    @department_module = department_modules(:one)
  end

  test "visiting the index" do
    visit department_modules_url
    assert_selector "h1", text: "Department modules"
  end

  test "should create department module" do
    visit department_modules_url
    click_on "New department module"

    fill_in "Department", with: @department_module.department_id
    fill_in "Module url", with: @department_module.module_url
    fill_in "Name", with: @department_module.name
    click_on "Create Department module"

    assert_text "Department module was successfully created"
    click_on "Back"
  end

  test "should update Department module" do
    visit department_module_url(@department_module)
    click_on "Edit this department module", match: :first

    fill_in "Department", with: @department_module.department_id
    fill_in "Module url", with: @department_module.module_url
    fill_in "Name", with: @department_module.name
    click_on "Update Department module"

    assert_text "Department module was successfully updated"
    click_on "Back"
  end

  test "should destroy Department module" do
    visit department_module_url(@department_module)
    click_on "Destroy this department module", match: :first

    assert_text "Department module was successfully destroyed"
  end
end
