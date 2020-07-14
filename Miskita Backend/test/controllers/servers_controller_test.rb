require 'test_helper'

class ServersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @server = servers(:one)
  end

  test "should get index" do
    get servers_url, as: :json
    assert_response :success
  end

  test "should create server" do
    assert_difference('Server.count') do
      post servers_url, params: { server: { title: @server.title } }, as: :json
    end

    assert_response 201
  end

  test "should show server" do
    get server_url(@server), as: :json
    assert_response :success
  end

  test "should update server" do
    patch server_url(@server), params: { server: { title: @server.title } }, as: :json
    assert_response 200
  end

  test "should destroy server" do
    assert_difference('Server.count', -1) do
      delete server_url(@server), as: :json
    end

    assert_response 204
  end
end
