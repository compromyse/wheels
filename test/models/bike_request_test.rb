require "test_helper"

class BikeRequestTest < ActiveSupport::TestCase
  def valid_bike_request
    BikeRequest.new(
      phone: "555-555-0000",
      requestor_name: "Test Person",
      due_date: Date.today + 7,
      bike_type: :male,
      distribution: distributions(:downtown_dist),
      production: productions(:main_production),
      user: users(:dist_user)
    )
  end

  # --- Validations ---

  test "valid bike request saves" do
    assert valid_bike_request.valid?
  end

  test "phone is required" do
    br = valid_bike_request
    br.phone = nil
    assert_not br.valid?
    assert_includes br.errors[:phone], "can't be blank"
  end

  test "bike_type is required" do
    br = valid_bike_request
    br.bike_type = nil
    assert_not br.valid?
    assert_includes br.errors[:bike_type], "can't be blank"
  end

  test "requestor_name is required" do
    br = valid_bike_request
    br.requestor_name = nil
    assert_not br.valid?
    assert_includes br.errors[:requestor_name], "can't be blank"
  end

  test "due_date is required" do
    br = valid_bike_request
    br.due_date = nil
    assert_not br.valid?
    assert_includes br.errors[:due_date], "can't be blank"
  end

  test "due_date must be in the future on create" do
    br = valid_bike_request
    br.due_date = Date.today
    assert_not br.valid?
    assert_includes br.errors[:due_date], "must be in the future"
  end

  test "due_date in past is invalid on create" do
    br = valid_bike_request
    br.due_date = Date.today - 1
    assert_not br.valid?
    assert_includes br.errors[:due_date], "must be in the future"
  end

  test "due_date validation skipped on update" do
    br = bike_requests(:requested_bike)
    br.due_date = Date.today - 1
    # update skips the :create context validation
    assert br.valid?
  end

  # --- Enum: bike_type ---

  test "bike_type male is valid" do
    br = valid_bike_request
    br.bike_type = :male
    assert br.valid?
    assert br.male?
  end

  test "bike_type female is valid" do
    br = valid_bike_request
    br.bike_type = :female
    assert br.valid?
    assert br.female?
  end

  test "bike_type kid is valid" do
    br = valid_bike_request
    br.bike_type = :kid
    assert br.valid?
    assert br.kid?
  end

  # --- Enum: status ---

  test "default status is requested" do
    br = valid_bike_request
    assert br.requested?
  end

  test "status transitions through all values" do
    br = bike_requests(:requested_bike)
    br.update!(status: :pending)
    assert br.pending?
    br.update!(status: :completed)
    assert br.completed?
    br.update!(status: :delivered)
    assert br.delivered?
    br.update!(status: :distributed)
    assert br.distributed?
  end

  # --- Associations ---

  test "belongs_to distribution" do
    br = bike_requests(:requested_bike)
    assert_equal distributions(:downtown_dist), br.distribution
  end

  test "belongs_to production" do
    br = bike_requests(:requested_bike)
    assert_equal productions(:main_production), br.production
  end

  test "belongs_to user" do
    br = bike_requests(:requested_bike)
    assert_equal users(:dist_user), br.user
  end

  test "assignee is optional" do
    br = bike_requests(:requested_bike)
    assert_nil br.assignee
    assert br.valid?
  end

  test "assignee is set on pending bike" do
    br = bike_requests(:pending_bike)
    assert_equal users(:prod_admin), br.assignee
  end
end
