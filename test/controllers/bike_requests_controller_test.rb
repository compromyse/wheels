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
    assert_redirected_to distribution_path(distributions(:downtown_dist))
  end

  test "create assigns current user as submitter" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    post distribution_bike_requests_path(distributions(:downtown_dist)),
         params: { bike_request: valid_bike_request_params }
    br = BikeRequest.last
    assert_equal users(:dist_user), br.user
  end

  test "create assigns distribution from URL" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    post distribution_bike_requests_path(distributions(:downtown_dist)),
         params: { bike_request: valid_bike_request_params }
    br = BikeRequest.last
    assert_equal distributions(:downtown_dist), br.distribution
  end

  test "create with invalid params re-renders new form" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    assert_no_difference "BikeRequest.count" do
      post distribution_bike_requests_path(distributions(:downtown_dist)),
           params: { bike_request: { phone: "", requestor_name: "", due_date: "", bike_type: "" } }
    end
    assert_response :unprocessable_entity
  end

  # --- update ---

  test "update requires authentication" do
    patch bike_request_path(bike_requests(:requested_bike)), params: { status: "pending" }
    assert_redirected_to login_path
  end

  test "update returns 403 for user without production access" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    patch bike_request_path(bike_requests(:requested_bike)), params: { status: "pending" }
    assert_response :forbidden
  end

  test "update pending sets status to pending and assigns current user as assignee" do
    br = bike_requests(:requested_bike)
    post login_path, params: { email: users(:prod_volunteer).email, password: "password" }
    patch bike_request_path(br), params: { status: "pending" }
    br.reload
    assert br.pending?
    assert_equal users(:prod_volunteer), br.assignee
  end

  test "update requested clears assignee" do
    br = bike_requests(:pending_bike)
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    patch bike_request_path(br), params: { status: "requested" }
    br.reload
    assert br.requested?
    assert_nil br.assignee
  end

  test "update completed sets status to completed" do
    br = bike_requests(:pending_bike)
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    patch bike_request_path(br), params: { status: "completed" }
    br.reload
    assert br.completed?
  end

  test "update delivered sets status to delivered" do
    br = bike_requests(:completed_bike)
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    patch bike_request_path(br), params: { status: "delivered" }
    br.reload
    assert br.delivered?
  end

  test "update distributed sets status to distributed" do
    br = bike_requests(:completed_bike)
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    patch bike_request_path(br), params: { status: "distributed" }
    br.reload
    assert br.distributed?
  end

  test "update redirects to production path with tab param" do
    br = bike_requests(:requested_bike)
    post login_path, params: { email: users(:prod_volunteer).email, password: "password" }
    patch bike_request_path(br), params: { status: "pending" }
    assert_redirected_to production_path(productions(:main_production), tab: "pending")
  end

  private

  test "update pending is blocked if assignee already has a pending request" do
    # prod_admin already has pending_bike assigned in fixtures
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    patch bike_request_path(bike_requests(:requested_bike)), params: { status: "pending" }
    assert_redirected_to production_path(productions(:main_production), tab: "requested")
    assert_match "already has a pending request", flash[:alert]
    assert bike_requests(:requested_bike).reload.requested?
  end

  test "new pre-populates due_date to two weeks from today" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    get new_distribution_bike_request_path(distributions(:downtown_dist))
    assert_equal Date.today + 14, assigns(:bike_request).due_date
  end

  def valid_bike_request_params
    {
      phone: "555-555-0001",
      requestor_name: "New Person",
      due_date: (Date.today + 14).to_s,
      bike_type: "male"
    }
  end
end
