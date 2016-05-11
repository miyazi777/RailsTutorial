require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do   # 未ログインユーザーがポストを投稿してもpostの数が変わらないことを確認
      post :create, micropost: {content: "Lorem ipsum"}
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do   # 未ログインユーザーがポストを削除してもpostの数が変わらないことを確認
      delete :destroy, id: @micropost 
    end
    assert_redirected_to login_url  # リダイレクトされていることを確認
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:test2))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do # 違うユーザーがポストを削除してもpostの数が変わらないことを確認
      delete :destroy, id: micropost 
    end
    assert_redirected_to root_url
  end

end
