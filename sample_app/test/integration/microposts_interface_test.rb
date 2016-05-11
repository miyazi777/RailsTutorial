require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test2)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'  # /にページネーションが表示されていることを確認

    # 無効な投稿を送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: {content: ""}
    end
    assert_select 'div#error_explanation' # 無効な投稿の場合、エラーメッセージが表示されることを確認

    # 有効な投稿を送信 
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do # 有効な投稿をすると投稿数が増えることを確認
      post microposts_path, micropost: {content: content}
    end
    assert_redirected_to root_url   # 有効な投稿をすると/に戻ってくることを確認
    follow_redirect!
    assert_match content, response.body # 投稿内容がレスポンスボディに含まれていることを確認

    # 投稿を削除する
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do  # 削除して投稿数が減ったことを確認
      delete micropost_path(first_micropost)
    end

    # 違うユーザーのプロフィールにアクセスする
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0 # 違うユーザーでアクセスした場合、deleteのリンクが表示されないことを確認
    
  end
end
