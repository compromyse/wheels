require "test_helper"

class ProductionsControllerTest < ActionDispatch::IntegrationTest
  test "show requires authentication" do
    get production_path(productions(:main_production))
    assert_redirected_to login_path
  end

  test "show returns 403 for user without production access" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    get production_path(productions(:main_production))
    assert_response :forbidden
  end

  test "show renders for authorized user" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    get production_path(productions(:main_production))
    assert_response :success
  end

  test "show defaults to requested tab" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    get production_path(productions(:main_production))
    assert_response :success
  end

  test "show accepts valid tab parameter" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    get production_path(productions(:main_production)), params: { tab: "pending" }
    assert_response :success
  end

  test "show ignores invalid tab parameter and defaults to requested" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    get production_path(productions(:main_production)), params: { tab: "badtab" }
    assert_response :success
  end

  test "show returns 404 for nonexistent production" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    get production_path(id: 999999)
    assert_response :not_found
  end

  test "show only returns bike requests belonging to this production" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    other_prod = Production.create!(name: "Other Production")
    other_request = BikeRequest.create!(
      phone: "555-000-0001", requestor_name: "Other", due_date: 10.days.from_now,
      bike_type: :male, distribution: distributions(:downtown_dist),
      production: other_prod, user: users(:dist_user)
    )
    get production_path(productions(:main_production)), params: { tab: "requested" }
    assert_response :success
    assert_not assigns(:bike_requests).include?(other_request)
  end
end
