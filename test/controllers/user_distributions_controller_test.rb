require "test_helper"

class UserDistributionsControllerTest < ActionDispatch::IntegrationTest
  def login_as_dist_admin
    post login_path, params: { email: users(:multi_user).email, password: "password" }
  end

  def login_as_superadmin
    post login_path, params: { email: users(:superadmin).email, password: "password" }
  end

  # --- create ---

  test "create requires authentication" do
    post distribution_user_distributions_path(distributions(:downtown_dist)),
      params: { user_id: users(:no_location_user).id, role: "volunteer" }
    assert_redirected_to login_path
  end

  test "create returns 403 for non-admin of that distribution" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    post distribution_user_distributions_path(distributions(:downtown_dist)),
      params: { user_id: users(:no_location_user).id, role: "volunteer" }
    assert_response :forbidden
  end

  test "create adds user to distribution for location admin" do
    login_as_dist_admin
    assert_difference "UserDistribution.count", 1 do
      post distribution_user_distributions_path(distributions(:downtown_dist)),
        params: { user_id: users(:no_location_user).id, role: "volunteer" }
    end
    assert_redirected_to users_distribution_path(distributions(:downtown_dist))
  end

  test "create adds user to distribution for superadmin" do
    login_as_superadmin
    assert_difference "UserDistribution.count", 1 do
      post distribution_user_distributions_path(distributions(:downtown_dist)),
        params: { user_id: users(:no_location_user).id, role: "volunteer" }
    end
    assert_redirected_to users_distribution_path(distributions(:downtown_dist))
  end

  test "create redirects with alert for unknown user" do
    login_as_dist_admin
    post distribution_user_distributions_path(distributions(:downtown_dist)),
      params: { user_id: 999999, role: "volunteer" }
    assert_redirected_to users_distribution_path(distributions(:downtown_dist))
    assert_equal "User not found.", flash[:alert]
  end

  test "create redirects with alert for duplicate assignment" do
    login_as_dist_admin
    post distribution_user_distributions_path(distributions(:downtown_dist)),
      params: { user_id: users(:dist_user).id, role: "volunteer" }
    assert_redirected_to users_distribution_path(distributions(:downtown_dist))
    assert flash[:alert].present?
  end

  # --- update ---

  test "update returns 403 for non-admin" do
    post login_path, params: { email: users(:prod_volunteer).email, password: "password" }
    ud = user_distributions(:dist_user_downtown)
    patch distribution_user_distribution_path(distributions(:downtown_dist), ud), params: { role: "admin" }
    assert_response :forbidden
  end

  test "update changes role for location admin" do
    login_as_dist_admin
    ud = UserDistribution.create!(user: users(:no_location_user), distribution: distributions(:downtown_dist), role: "volunteer")
    patch distribution_user_distribution_path(distributions(:downtown_dist), ud), params: { role: "admin" }
    assert_redirected_to users_distribution_path(distributions(:downtown_dist))
    assert_equal "admin", ud.reload.role
  end

  test "update rejects invalid role" do
    login_as_dist_admin
    ud = UserDistribution.create!(user: users(:no_location_user), distribution: distributions(:downtown_dist), role: "volunteer")
    patch distribution_user_distribution_path(distributions(:downtown_dist), ud), params: { role: "superuser" }
    assert_redirected_to users_distribution_path(distributions(:downtown_dist))
    assert_equal flash[:alert], "Invalid role."
  end

  # --- destroy ---

  test "destroy returns 403 for non-admin" do
    post login_path, params: { email: users(:prod_volunteer).email, password: "password" }
    ud = user_distributions(:dist_user_downtown)
    delete distribution_user_distribution_path(distributions(:downtown_dist), ud)
    assert_response :forbidden
  end

  test "destroy removes membership for location admin" do
    login_as_dist_admin
    ud = UserDistribution.create!(user: users(:no_location_user), distribution: distributions(:downtown_dist), role: "volunteer")
    assert_difference "UserDistribution.count", -1 do
      delete distribution_user_distribution_path(distributions(:downtown_dist), ud)
    end
    assert_redirected_to users_distribution_path(distributions(:downtown_dist))
  end
end
