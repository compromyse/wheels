require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated request redirects to login" do
    get root_path
    assert_redirected_to login_path
  end

  test "superadmin with no location assignments redirects to /admin" do
    post login_path, params: { email: users(:superadmin).email, password: "password" }
    get root_path
    assert_redirected_to admin_root_path
  end

  test "single-location production user redirects to production dashboard" do
    user = users(:prod_admin)
    post login_path, params: { email: user.email, password: "password" }
    get root_path
    assert_redirected_to production_path(productions(:main_production))
  end

  test "single-location distribution user redirects to distribution dashboard" do
    user = users(:dist_user)
    post login_path, params: { email: user.email, password: "password" }
    get root_path
    assert_redirected_to distribution_path(distributions(:downtown_dist))
  end

  test "multi-location user renders home page" do
    user = users(:multi_user)
    post login_path, params: { email: user.email, password: "password" }
    get root_path
    assert_response :success
  end

  test "superadmin with a location assignment renders home page (not admin redirect)" do
    user = users(:superadmin_with_location)
    post login_path, params: { email: user.email, password: "password" }
    get root_path
    # Has exactly one production location — redirects to that production
    assert_redirected_to production_path(productions(:main_production))
  end
end
