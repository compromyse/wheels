require "test_helper"

class Admin::DistributionsControllerTest < ActionDispatch::IntegrationTest
  def login_as_superadmin
    post login_path, params: { email: users(:superadmin).email, password: "password" }
  end

  def login_as_regular_user
    post login_path, params: { email: users(:dist_user).email, password: "password" }
  end

  # --- index ---

  test "index requires authentication" do
    get admin_distributions_path
    assert_redirected_to login_path
  end

  test "index returns 403 for non-superadmin" do
    login_as_regular_user
    get admin_distributions_path
    assert_response :forbidden
  end

  test "index lists all distributions for superadmin" do
    login_as_superadmin
    get admin_distributions_path
    assert_response :success
  end

  # --- new ---

  test "new requires superadmin" do
    login_as_regular_user
    get new_admin_distribution_path
    assert_response :forbidden
  end

  test "new renders form for superadmin" do
    login_as_superadmin
    get new_admin_distribution_path
    assert_response :success
  end

  # --- create ---

  test "create requires superadmin" do
    login_as_regular_user
    post admin_distributions_path, params: { distribution: { name: "Test Dist" } }
    assert_response :forbidden
  end

  test "create saves distribution with name and redirects to index" do
    login_as_superadmin
    assert_difference "Distribution.count", 1 do
      post admin_distributions_path, params: { distribution: { name: "New Center", address: "789 Elm St" } }
    end
    assert_redirected_to admin_distributions_path
    assert_equal "789 Elm St", Distribution.last.address
  end

  test "create with invalid params re-renders new form" do
    login_as_superadmin
    assert_no_difference "Distribution.count" do
      post admin_distributions_path, params: { distribution: { name: "" } }
    end
    assert_response :unprocessable_entity
  end

  # --- edit ---

  test "edit requires superadmin" do
    login_as_regular_user
    get edit_admin_distribution_path(distributions(:downtown_dist))
    assert_response :forbidden
  end

  test "edit renders form for superadmin" do
    login_as_superadmin
    get edit_admin_distribution_path(distributions(:downtown_dist))
    assert_response :success
  end

  # --- update ---

  test "update requires superadmin" do
    login_as_regular_user
    patch admin_distribution_path(distributions(:downtown_dist)),
          params: { distribution: { name: "Changed" } }
    assert_response :forbidden
  end

  test "update changes name and address and redirects to index" do
    login_as_superadmin
    dist = distributions(:downtown_dist)
    patch admin_distribution_path(dist),
          params: { distribution: { name: "Updated Name", address: "999 New Rd" } }
    assert_redirected_to admin_distributions_path
    dist.reload
    assert_equal "Updated Name", dist.name
    assert_equal "999 New Rd", dist.address
  end

  test "update with invalid params re-renders edit form" do
    login_as_superadmin
    patch admin_distribution_path(distributions(:downtown_dist)),
          params: { distribution: { name: "" } }
    assert_response :unprocessable_entity
  end

  # --- destroy ---

  test "destroy requires superadmin" do
    login_as_regular_user
    delete admin_distribution_path(distributions(:downtown_dist))
    assert_response :forbidden
  end

  test "destroy removes distribution and redirects to index" do
    login_as_superadmin
    dist = Distribution.create!(name: "Temporary Dist")
    assert_difference "Distribution.count", -1 do
      delete admin_distribution_path(dist)
    end
    assert_redirected_to admin_distributions_path
  end
end
