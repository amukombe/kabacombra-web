require "test_helper"

class SystemModulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_module = system_modules(:one)
  end

  test "should get index" do
    get system_modules_url
    assert_response :success
  end

  test "should get new" do
    get new_system_module_url
    assert_response :success
  end

  test "should create system_module" do
    assert_difference("SystemModule.count") do
      post system_modules_url, params: { system_module: { department_id: @system_module.department_id, icon: @system_module.icon, module_url: @system_module.module_url, name: @system_module.name } }
    end

    assert_redirected_to system_module_url(SystemModule.last)
  end

  test "should show system_module" do
    get system_module_url(@system_module)
    assert_response :success
  end

  test "should get edit" do
    get edit_system_module_url(@system_module)
    assert_response :success
  end

  test "should update system_module" do
    patch system_module_url(@system_module), params: { system_module: { department_id: @system_module.department_id, icon: @system_module.icon, module_url: @system_module.module_url, name: @system_module.name } }
    assert_redirected_to system_module_url(@system_module)
  end

  test "should destroy system_module" do
    assert_difference("SystemModule.count", -1) do
      delete system_module_url(@system_module)
    end

    assert_redirected_to system_modules_url
  end
end
