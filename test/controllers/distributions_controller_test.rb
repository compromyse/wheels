require "test_helper"

class DistributionsControllerTest < ActionDispatch::IntegrationTest
  test "show requires authentication" do
    get tickets_distribution_path(distributions(:downtown_dist))
    assert_redirected_to login_path
  end

  test "show allows superadmin without explicit distribution assignment" do
    post login_path, params: { email: users(:superadmin).email, password: "password" }
    get tickets_distribution_path(distributions(:downtown_dist))
    assert_response :success
  end

  test "show returns 403 for user without distribution access" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    get tickets_distribution_path(distributions(:downtown_dist))
    assert_response :forbidden
  end

  test "show renders for authorized user" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    get tickets_distribution_path(distributions(:downtown_dist))
    assert_response :success
  end

  test "show defaults to requested tab" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    get tickets_distribution_path(distributions(:downtown_dist))
    assert_response :success
  end

  test "show accepts valid tab parameter" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    get tickets_distribution_path(distributions(:downtown_dist)), params: { tab: "completed" }
    assert_response :success
  end

  test "show ignores invalid tab and defaults to requested" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    get tickets_distribution_path(distributions(:downtown_dist)), params: { tab: "invalid" }
    assert_response :success
  end

  test "show returns 404 for nonexistent distribution" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    get tickets_distribution_path(id: 999999)
    assert_response :not_found
  end

  test "show only returns bike requests belonging to this distribution" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    other_request = BikeRequest.create!(
      phone: "5550000002", requestor_name: "Other", due_date: 10.days.from_now,
      bike_type: :male, distribution: distributions(:uptown_dist),
      production: productions(:main_production), user: users(:dist_user)
    )
    get tickets_distribution_path(distributions(:downtown_dist)), params: { tab: "requested" }
    assert_response :success
    assert_not assigns(:bike_requests).include?(other_request)
  end

  # --- users action ---

  test "users requires authentication" do
    get users_distribution_path(distributions(:downtown_dist))
    assert_redirected_to login_path
  end

  test "users returns 403 for non-admin member" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    get users_distribution_path(distributions(:downtown_dist))
    assert_response :forbidden
  end

  test "users renders for distribution admin" do
    post login_path, params: { email: users(:multi_user).email, password: "password" }
    get users_distribution_path(distributions(:downtown_dist))
    assert_response :success
    assert_not_nil assigns(:members)
  end

  test "users renders for superadmin" do
    post login_path, params: { email: users(:superadmin).email, password: "password" }
    get users_distribution_path(distributions(:downtown_dist))
    assert_response :success
  end

  test "users sets member search results when query is present" do
    post login_path, params: { email: users(:multi_user).email, password: "password" }
    get users_distribution_path(distributions(:downtown_dist)), params: { member_query: users(:no_location_user).name }
    assert_response :success
    assert_includes assigns(:member_search_results), users(:no_location_user)
  end

  test "users excludes already-assigned users from search results" do
    post login_path, params: { email: users(:multi_user).email, password: "password" }
    get users_distribution_path(distributions(:downtown_dist)), params: { member_query: users(:dist_user).name }
    assert_response :success
    assert_not_includes assigns(:member_search_results), users(:dist_user)
  end
end
