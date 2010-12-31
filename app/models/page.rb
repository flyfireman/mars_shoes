class Page < ActiveRecord::Base
  attr_accessible :title, :permalink, :body
  validates_presence_of :title, :body, :message => "不能为空"
  validates_length_of :title, :within => 3..255, :message => "长度不正确"
  validates_length_of :body, :maximum =>10000, :message => "超过最大值"

  def before_create
    @attributes['permalink'] = title.downcase.gsub(/\s+/,'_').gsub(/[^a-zA-Z0-9]+/,'')
  end

  def to_param
    "#{id}-#{permalink}"
  end
end
