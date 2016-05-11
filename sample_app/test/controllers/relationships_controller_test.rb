require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do  # ログインしていないユーザーがフォローしてもフォロー数が変わらないことを確認
      post :create
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do # ログインいていないユーザーがフォローを外してもフォロー数が変わらないことを確認
      delete :destroy, id: relationships(:one)
    end
  end
end
