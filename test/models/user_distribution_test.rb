require "test_helper"

class UserDistributionTest < ActiveSupport::TestCase
  def valid_user_distribution
    UserDistribution.new(
      user: users(:no_location_user),
      distribution: distributions(:downtown_dist),
      role: "volunteer"
    )
  end

  test "valid user distribution saves" do
    assert valid_user_distribution.valid?
  end

  test "role volunteer is valid" do
    ud = valid_user_distribution
    ud.role = "volunteer"
    assert ud.valid?
  end

  test "role admin is valid" do
    ud = valid_user_distribution
    ud.role = "admin"
    assert ud.valid?
  end

  test "role blank is invalid" do
    ud = valid_user_distribution
    ud.role = ""
    assert_not ud.valid?
    assert_includes ud.errors[:role], "is not included in the list"
  end

  test "role arbitrary string is invalid" do
    ud = valid_user_distribution
    ud.role = "manager"
    assert_not ud.valid?
    assert_includes ud.errors[:role], "is not included in the list"
  end

  test "user_id and distribution_id must be unique together" do
    existing = user_distributions(:dist_user_downtown)
    duplicate = UserDistribution.new(user: existing.user, distribution: existing.distribution, role: "volunteer")
    assert_not duplicate.valid?
  end
end
