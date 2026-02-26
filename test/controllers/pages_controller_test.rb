require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should get v1" do
    get "/1"
    assert_response :success
  end

  test "should get v2" do
    get "/2"
    assert_response :success
  end

  test "should get v3" do
    get "/3"
    assert_response :success
  end

  test "should get v4" do
    get "/4"
    assert_response :success
  end

  test "should get v5" do
    get "/5"
    assert_response :success
  end

  test "should get v6" do
    get "/6"
    assert_response :success
  end

  test "should get v7" do
    get "/7"
    assert_response :success
  end

  test "should get v8" do
    get "/8"
    assert_response :success
  end

  test "should get v9" do
    get "/9"
    assert_response :success
  end

  test "should get v10" do
    get "/10"
    assert_response :success
  end
end
