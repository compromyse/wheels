require "test_helper"

class Admin::ProductionsControllerTest < ActionDispatch::IntegrationTest
  def login_as_superadmin
    post login_path, params: { email: users(:superadmin).email, password: "password" }
  end

  def login_as_regular_user
    post login_path, params: { email: users(:prod_admin).email, password: "password" }
  end

  # --- index ---

  test "index requires authentication" do
    get admin_productions_path
    assert_redirected_to login_path
  end

  test "index returns 403 for non-superadmin" do
    login_as_regular_user
    get admin_productions_path
    assert_response :forbidden
  end

  test "index lists all productions for superadmin" do
    login_as_superadmin
    get admin_productions_path
    assert_response :success
  end

  # --- new ---

  test "new requires superadmin" do
    login_as_regular_user
    get new_admin_production_path
    assert_response :forbidden
  end

  test "new renders form for superadmin" do
    login_as_superadmin
    get new_admin_production_path
    assert_response :success
  end

  # --- create ---

  test "create requires superadmin" do
    login_as_regular_user
    post admin_productions_path, params: { production: { name: "Test" } }
    assert_response :forbidden
  end

  test "create saves production and redirects to index" do
    login_as_superadmin
    assert_difference "Production.count", 1 do
      post admin_productions_path, params: { production: { name: "New Factory" } }
    end
    assert_redirected_to admin_productions_path
  end

  test "create with invalid params re-renders new form" do
    login_as_superadmin
    assert_no_difference "Production.count" do
      post admin_productions_path, params: { production: { name: "" } }
    end
    assert_response :unprocessable_entity
  end

  # --- destroy ---

  test "destroy requires superadmin" do
    login_as_regular_user
    delete admin_production_path(productions(:second_production))
    assert_response :forbidden
  end

  test "destroy removes production and redirects to index" do
    login_as_superadmin
    prod = Production.create!(name: "Temporary")
    assert_difference "Production.count", -1 do
      delete admin_production_path(prod)
    end
    assert_redirected_to admin_productions_path
  end
end
