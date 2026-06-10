require "test_helper"

class UserProductionsControllerTest < ActionDispatch::IntegrationTest
  def login_as_prod_admin
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
  end

  def login_as_prod_volunteer
    post login_path, params: { email: users(:prod_volunteer).email, password: "password" }
  end

  def login_as_superadmin
    post login_path, params: { email: users(:superadmin).email, password: "password" }
  end

  # --- create ---

  test "create requires authentication" do
    post production_user_productions_path(productions(:main_production)),
      params: { user_id: users(:no_location_user).id, role: "volunteer" }
    assert_redirected_to login_path
  end

  test "create returns 403 for volunteer" do
    login_as_prod_volunteer
    post production_user_productions_path(productions(:main_production)),
      params: { user_id: users(:no_location_user).id, role: "volunteer" }
    assert_response :forbidden
  end

  test "create adds user to production for location admin" do
    login_as_prod_admin
    assert_difference "UserProduction.count", 1 do
      post production_user_productions_path(productions(:main_production)),
        params: { user_id: users(:no_location_user).id, role: "volunteer" }
    end
    assert_redirected_to users_production_path(productions(:main_production))
  end

  test "create adds user to production for superadmin" do
    login_as_superadmin
    assert_difference "UserProduction.count", 1 do
      post production_user_productions_path(productions(:main_production)),
        params: { user_id: users(:no_location_user).id, role: "admin" }
    end
    assert_redirected_to users_production_path(productions(:main_production))
  end

  test "create redirects with alert for unknown user" do
    login_as_prod_admin
    post production_user_productions_path(productions(:main_production)),
      params: { user_id: 999999, role: "volunteer" }
    assert_redirected_to users_production_path(productions(:main_production))
    assert_equal "User not found.", flash[:alert]
  end

  test "create redirects with alert for duplicate assignment" do
    login_as_prod_admin
    post production_user_productions_path(productions(:main_production)),
      params: { user_id: users(:prod_admin).id, role: "volunteer" }
    assert_redirected_to users_production_path(productions(:main_production))
    assert flash[:alert].present?
  end

  # --- update ---

  test "update returns 403 for volunteer" do
    login_as_prod_volunteer
    up = user_productions(:prod_admin_main)
    patch production_user_production_path(productions(:main_production), up), params: { role: "volunteer" }
    assert_response :forbidden
  end

  test "update changes role for location admin" do
    login_as_prod_admin
    up = UserProduction.create!(user: users(:no_location_user), production: productions(:main_production), role: "volunteer")
    patch production_user_production_path(productions(:main_production), up), params: { role: "admin" }
    assert_redirected_to users_production_path(productions(:main_production))
    assert_equal "admin", up.reload.role
  end

  test "update rejects invalid role" do
    login_as_prod_admin
    up = UserProduction.create!(user: users(:no_location_user), production: productions(:main_production), role: "volunteer")
    patch production_user_production_path(productions(:main_production), up), params: { role: "superuser" }
    assert_redirected_to users_production_path(productions(:main_production))
    assert_equal flash[:alert], "Invalid role."
  end

  # --- destroy ---

  test "destroy returns 403 for volunteer" do
    login_as_prod_volunteer
    up = user_productions(:prod_admin_main)
    delete production_user_production_path(productions(:main_production), up)
    assert_response :forbidden
  end

  test "destroy removes membership for location admin" do
    login_as_prod_admin
    up = UserProduction.create!(user: users(:no_location_user), production: productions(:main_production), role: "volunteer")
    assert_difference "UserProduction.count", -1 do
      delete production_user_production_path(productions(:main_production), up)
    end
    assert_redirected_to users_production_path(productions(:main_production))
  end
end
