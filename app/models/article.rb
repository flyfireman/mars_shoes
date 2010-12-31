class Article < ActiveRecord::Base
  attr_accessible :user_id, :title, :synopsis, :body, :published, :published_at, :category_id
  belongs_to :user  #现在只要使用user.aritcles,你就可以轻松地查阅到指定用户的所有文章,反之,你也可以使用aricle.user来找到文章的作者
  belongs_to :category
  validates_presence_of :title, :synopsis, :body, :message => "不能为空"
  validates_length_of   :title, :maximum => 255, :message => "长度不正确"
  validates_length_of   :synopsis, :maximum => 1000, :message => "长度不正确"
  validates_length_of   :title, :maximum => 20000, :message => "长度不正确"

  before_save :upadte_published_at
  #用before_save回调方法来确保文章被保存且published属性被设置为true时,应用程序能够自动更新published_at字段
  def update_published_ad
    self.published_at = Time.now if published == true
  end
end
