require "test_helper"

class DepartmentModulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @department_module = department_modules(:one)
  end

  test "should get index" do
    get department_modules_url
    assert_response :success
  end

  test "should get new" do
    get new_department_module_url
    assert_response :success
  end

  test "should create department_module" do
    assert_difference("DepartmentModule.count") do
      post department_modules_url, params: { department_module: { department_id: @department_module.department_id, module_url: @department_module.module_url, name: @department_module.name } }
    end

    assert_redirected_to department_module_url(DepartmentModule.last)
  end

  test "should show department_module" do
    get department_module_url(@department_module)
    assert_response :success
  end

  test "should get edit" do
    get edit_department_module_url(@department_module)
    assert_response :success
  end

  test "should update department_module" do
    patch department_module_url(@department_module), params: { department_module: { department_id: @department_module.department_id, module_url: @department_module.module_url, name: @department_module.name } }
    assert_redirected_to department_module_url(@department_module)
  end

  test "should destroy department_module" do
    assert_difference("DepartmentModule.count", -1) do
      delete department_module_url(@department_module)
    end

    assert_redirected_to department_modules_url
  end
end
