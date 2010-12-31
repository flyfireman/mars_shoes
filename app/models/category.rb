class Category < ActiveRecord::Base
  attr_accessible :name
  has_many :articles, :dependent => :nullify #当一种分类被删除时,其下所有文章的category_id都应被置为null.
  #:dependent => :destroy_all和:delete_all是另外两个方法.主要用于删除关联对象.delete_all比destroy_all快无数倍,不过要慎用
  #现在只要使用category.aritcles,你就可以轻松地查阅到指定类型的所有文章,
  #反之,你也可以使用aricle.category来找到文章的分类
  validates_length_of :name, :maximum => 80, :message => "长度不正确"
end
