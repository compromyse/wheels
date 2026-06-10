require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  # --- new ---

  test "new renders signup form" do
    get signup_path
    assert_response :success
  end

  test "new redirects to root if already logged in" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    get signup_path
    assert_redirected_to root_path
  end

  # --- create ---

  test "create with valid params creates user, logs in, and redirects to root" do
    assert_difference "User.count", 1 do
      post signup_path, params: { user: {
        name: "New Person",
        email: "newperson@example.com",
        password: "password",
        password_confirmation: "password"
      } }
    end
    assert_redirected_to root_path
    assert_equal User.find_by(email: "newperson@example.com").id, session[:user_id]
  end

  test "create does not set superadmin regardless of params" do
    post signup_path, params: { user: {
      name: "Hacker",
      email: "hacker@example.com",
      password: "password",
      password_confirmation: "password",
      superadmin: true
    } }
    user = User.find_by(email: "hacker@example.com")
    assert_not_nil user
    assert_not user.superadmin?
  end

  test "create with invalid params re-renders form" do
    assert_no_difference "User.count" do
      post signup_path, params: { user: {
        name: "",
        email: "bad",
        password: "password",
        password_confirmation: "wrong"
      } }
    end
    assert_response :unprocessable_entity
  end

  test "create with duplicate email re-renders form" do
    assert_no_difference "User.count" do
      post signup_path, params: { user: {
        name: "Duplicate",
        email: users(:prod_admin).email,
        password: "password",
        password_confirmation: "password"
      } }
    end
    assert_response :unprocessable_entity
  end

  test "new user has no location assignments" do
    post signup_path, params: { user: {
      name: "Fresh User",
      email: "fresh@example.com",
      password: "password",
      password_confirmation: "password"
    } }
    user = User.find_by(email: "fresh@example.com")
    assert user.all_locations.empty?
  end
end
