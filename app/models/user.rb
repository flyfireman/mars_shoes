require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login, :message => "不能为空"
  validates_length_of       :login,    :within => 3..40, :message => "长度不正确"
  validates_uniqueness_of  :login, :message => "已存在"
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email, :message => "不能为空"
  validates_length_of       :email,    :within => 6..100,:message => "长度不正确" #r@a.wk
  validates_uniqueness_of   :email, :message => "已存在"
  #============email正则验证========== /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i================#
  validates_format_of       :email,:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i ,:message=> "不合格的Email"
  #(1)字面字符,表示"与该字符匹配",如/a/ =~ "a"
  #(2)圆点通配符(.),表示"与任意一个字符匹配",如 /./ = "%w(a b c d ... w)"
  #(3)字符类,表示"与这些字符中的一个匹配",如/[dr]ejected/,表示"匹配d或r,后接ejected"
  #(4)常见字符集的特殊转义序列: /[0-9]/ => /\d/ || /\w/ => /[0-9a-zA-Z_][]/ || /\s/ 与任何空白字符(空格、制表符、换行符)想匹配
  #(5)用小括号来捕获子匹配
  #str = "Peel, Emma,Mrs.,talented amateur"
  #/([A-Za-z]+),[A-Za-z]+,(Mrs?\.)/.march(str) Ruby填写的这些变量都是全局变量,它们以数作为名字:$1,$2,等等.
  #$1包含正则表达式从左侧开始的第一对小括号内的子模式所匹配的子字符串(规则为:在匹配操作成功后,变量$n(n是一个数)包含正则表达式从
  #左侧开始的第n对小括号内的子模式所匹配的子字符串) puts "Dear #{$2} #{$1}," => Dear Mrs.Peel,
  #(6)？ => "0个或1个"  * => "0个或多个" + => "1个或多个"
  #(7)特定次数的重复,如指定子模式的具体重复次数 /\d{3}-\d{4}/
  #也可指定一个范围/\d{1,10}/
  #单个数值后面跟一个逗号用于指定最小重复数(n或更多重复次数),如/\d{3,}/
  #(8)断言和锚都不会消耗任何字符.相反,它们表示一个限制条件,这个条件必须满足才能继续进行字符的匹配.
  #^ => "行首"   $ => "行尾"  \A =>字符串的开始  \z => 字符串的结尾  \Z => 字符串的结尾(不包括最后的换行符) \b => 单词边界
  #(9)修饰语它是一个字母,它位于正则表达式最后那个用于结束正则表达式的正斜杠的后面:
  #/abc/i 这里的i使得设计该正则表达式的匹配操作大小写不敏感.
  #/abc/m 这里的m使得圆点通配符可以与任何字符相匹配,包括换行符.
  #(10)scan方法从左到右扫描一个字符串,重复地进行测试以寻找指定模式的各个匹配,结果返回到一个数组中.
  #如"testing 1 2 3 testing 4 5 6".scan(/\d/)  => %w(1 2 3 4 5 6 )
  #(11)split方法会将一个字符串分割为几个子字符串,并返回到一个数组中.
  #"Ruby".split(//) => %w(R u b y)
  #(12)grep方法把与作为参数提供的正则表达式匹配的所有元素返回到一个数组(或者其他可枚举的对象)
  #["USA", "UK", "France", "Germany"].grep(/[a-z]/) => ["France", "Germany"]


  before_create :make_activation_code 

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :roles
  #=========对应关系==========#
  has_many :articles

  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  #====about roles====#
  def role_symbols
    @role_symbols ||= (roles || []).map {|r| r.to_sym}
  end

  protected
    

  def make_activation_code
  
    self.activation_code = self.class.make_token
  end


end
