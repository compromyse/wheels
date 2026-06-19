require "test_helper"

class BikeRequestsControllerTest < ActionDispatch::IntegrationTest
  # --- new ---

  test "new requires authentication" do
    get new_distribution_bike_request_path(distributions(:downtown_dist))
    assert_redirected_to login_path
  end

  test "new returns 403 for user without distribution access" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    get new_distribution_bike_request_path(distributions(:downtown_dist))
    assert_response :forbidden
  end

  test "new renders form for authorized distribution user" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    get new_distribution_bike_request_path(distributions(:downtown_dist))
    assert_response :success
  end

  test "new pre-populates due_date to two weeks from today" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    get new_distribution_bike_request_path(distributions(:downtown_dist))
    assert_equal Date.today + 14, assigns(:bike_request).due_date
  end

  # --- create ---

  test "create requires authentication" do
    post distribution_bike_requests_path(distributions(:downtown_dist)),
         params: { bike_request: valid_bike_request_params }
    assert_redirected_to login_path
  end

  test "create returns 403 for user without distribution access" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    post distribution_bike_requests_path(distributions(:downtown_dist)),
         params: { bike_request: valid_bike_request_params }
    assert_response :forbidden
  end

  test "create saves record and redirects to distribution" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    assert_difference "BikeRequest.count", 1 do
      post distribution_bike_requests_path(distributions(:downtown_dist)),
           params: { bike_request: valid_bike_request_params }
    end
    assert_redirected_to tickets_distribution_path(distributions(:downtown_dist))
  end

  test "create saves nested bikes" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    assert_difference "Bike.count", 2 do
      post distribution_bike_requests_path(distributions(:downtown_dist)),
           params: { bike_request: valid_bike_request_params_with_two_bikes }
    end
  end

  test "create assigns current user as submitter" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    post distribution_bike_requests_path(distributions(:downtown_dist)),
         params: { bike_request: valid_bike_request_params }
    assert_equal users(:dist_user), BikeRequest.last.user
  end

  test "create assigns distribution from URL" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    post distribution_bike_requests_path(distributions(:downtown_dist)),
         params: { bike_request: valid_bike_request_params }
    assert_equal distributions(:downtown_dist), BikeRequest.last.distribution
  end

  test "create with invalid params re-renders new form" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    assert_no_difference "BikeRequest.count" do
      post distribution_bike_requests_path(distributions(:downtown_dist)),
           params: { bike_request: { phone: "", requestor_name: "", due_date: "" } }
    end
    assert_response :unprocessable_entity
  end

  # --- update ---

  test "update requires authentication" do
    patch bike_request_path(bike_requests(:completed_bike)), params: { status: "delivered" }
    assert_redirected_to login_path
  end

  test "update returns 403 for user without production access" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    patch bike_request_path(bike_requests(:completed_bike)), params: { status: "delivered" }
    assert_response :forbidden
  end

  test "update delivered sets status to delivered" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    patch bike_request_path(bike_requests(:completed_bike)), params: { status: "delivered" }
    assert bike_requests(:completed_bike).reload.delivered?
  end

  test "update distributed sets status to distributed" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    patch bike_request_path(bike_requests(:completed_bike)), params: { status: "distributed" }
    assert bike_requests(:completed_bike).reload.distributed?
  end

  test "update redirects to production path with tab param" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    patch bike_request_path(bike_requests(:completed_bike)), params: { status: "delivered" }
    assert_redirected_to tickets_production_path(productions(:main_production), tab: "delivered")
  end

  private

  def valid_bike_request_params
    {
      phone: "5555550001",
      requestor_name: "New Person",
      due_date: (Date.today + 14).to_s,
      bikes_attributes: { "0" => { bike_type: "male" } }
    }
  end

  def valid_bike_request_params_with_two_bikes
    {
      phone: "5555550002",
      requestor_name: "Two Bikes",
      due_date: (Date.today + 14).to_s,
      bikes_attributes: {
        "0" => { bike_type: "male", name: "Alice" },
        "1" => { bike_type: "female", name: "Bob" }
      }
    }
  end
end
