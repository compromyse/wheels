require "test_helper"

class BikesControllerTest < ActionDispatch::IntegrationTest
  test "update requires authentication" do
    patch bike_path(bikes(:requested_bike_bike))
    assert_redirected_to login_path
  end

  test "update returns 403 for user without production access" do
    post login_path, params: { email: users(:dist_user).email, password: "password" }
    patch bike_path(bikes(:requested_bike_bike))
    assert_response :forbidden
  end

  test "update toggles bike from incomplete to complete" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    bike = bikes(:requested_bike_bike)
    assert_not bike.completed
    patch bike_path(bike)
    assert bike.reload.completed
  end

  test "update toggles bike from complete to incomplete" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    bike = bikes(:completed_bike_bike_one)
    assert bike.completed
    patch bike_path(bike)
    assert_not bike.reload.completed
  end

  test "completing last bike on a request moves request to completed" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    bike = bikes(:requested_bike_bike)
    assert bike.bike_request.requested?
    patch bike_path(bike)
    assert bike.bike_request.reload.completed?
  end

  test "uncompleting a bike on a completed request moves request back to requested" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    bike = bikes(:completed_bike_bike_one)
    assert bike.bike_request.completed?
    patch bike_path(bike)
    assert bike.bike_request.reload.requested?
  end

  test "update redirects to production tickets with correct tab" do
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
    patch bike_path(bikes(:requested_bike_bike))
    assert_redirected_to tickets_production_path(productions(:main_production), tab: "completed")
  end
end
