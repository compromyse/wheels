require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "GET /login renders login form" do
    get login_path
    assert_response :success
  end

  test "GET /login redirects to root if already logged in" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    get login_path
    assert_redirected_to root_path
  end

  test "POST /login with valid credentials sets session and redirects" do
    user = users(:prod_admin)
    post login_path, params: { email: user.email, password: "password" }
    assert_redirected_to root_path
    assert_equal user.id, session[:user_id]
  end

  test "POST /login with invalid password re-renders form without setting session" do
    user = users(:prod_admin)
    post login_path, params: { email: user.email, password: "wrong" }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "POST /login with unknown email re-renders form without setting session" do
    post login_path, params: { email: "nobody@example.com", password: "password" }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "POST /login single-production user follows redirect to production dashboard" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    follow_redirect!
    assert_redirected_to production_path(productions(:main_production))
  end

  test "POST /login single-distribution user follows redirect to distribution dashboard" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    follow_redirect!
    assert_redirected_to distribution_path(distributions(:downtown_dist))
  end

  test "POST /login multi-location user stays on home page" do
    post login_path, params: { email: users(:multi_user).email, password: "password" }
    follow_redirect!
    assert_response :success
  end

  test "POST /login superadmin with no locations redirects to admin panel" do
    post login_path, params: { email: users(:superadmin).email, password: "password" }
    follow_redirect!
    assert_redirected_to admin_root_path
  end

  test "DELETE /logout clears session and redirects to login" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    assert_not_nil session[:user_id]

    delete logout_path
    assert_redirected_to login_path
    assert_nil session[:user_id]
  end
end
