class Page < ActiveRecord::Base
  attr_accessible :title, :permalink, :body
  validates_presence_of :title, :body
  validates_length_of :title, :within => 3..255
  validates_length_of :body, :maximum =>10000

  def before_create
    @attributes['permalink'] = title.downcase.gsub(/\s+/,'_').gsub(/[^a-zA-Z0-9]+/,'')
  end

  def to_param
    "#{id}-#{permalink}"
  end
end
