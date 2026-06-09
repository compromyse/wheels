require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "index requires authentication" do
    get admin_root_path
    assert_redirected_to login_path
  end

  test "index returns 403 for non-superadmin" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    get admin_root_path
    assert_response :forbidden
  end

  test "index renders for superadmin" do
    post login_path, params: { email: users(:superadmin).email, password: "password" }
    get admin_root_path
    assert_response :success
  end

  test "index assigns productions, distributions, and users" do
    post login_path, params: { email: users(:superadmin).email, password: "password" }
    get admin_root_path
    assert_response :success
    assert_not_nil assigns(:productions)
    assert_not_nil assigns(:distributions)
    assert_not_nil assigns(:users)
  end
end
