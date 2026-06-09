require "test_helper"

class UserProductionTest < ActiveSupport::TestCase
  def valid_user_production
    UserProduction.new(
      user: users(:no_location_user),
      production: productions(:main_production),
      role: "volunteer"
    )
  end

  test "valid user production saves" do
    assert valid_user_production.valid?
  end

  test "role volunteer is valid" do
    up = valid_user_production
    up.role = "volunteer"
    assert up.valid?
  end

  test "role admin is valid" do
    up = valid_user_production
    up.role = "admin"
    assert up.valid?
  end

  test "role blank is invalid" do
    up = valid_user_production
    up.role = ""
    assert_not up.valid?
    assert_includes up.errors[:role], "is not included in the list"
  end

  test "role arbitrary string is invalid" do
    up = valid_user_production
    up.role = "manager"
    assert_not up.valid?
    assert_includes up.errors[:role], "is not included in the list"
  end

  test "user_id and production_id must be unique together" do
    existing = user_productions(:prod_admin_main)
    duplicate = UserProduction.new(user: existing.user, production: existing.production, role: "volunteer")
    assert_not duplicate.valid?
  end
end
