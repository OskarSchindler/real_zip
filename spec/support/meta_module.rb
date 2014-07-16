# this file gona be gem!
# 
# TODO:
# use Modules.call as a default method, instead of using used do


class MetaModule < Module
  # use .new so I don't bother user to use super in #initialize
  def self.new(*)
    super.tap { |x| x.send :include, self::Methods }
  end

  def self.used &block
    define_method :included, &block
    define_method :extended, &block
  end
end



class MetaModule2 #< Class
  def self.new *params
    _params = params.join ?,
    a_params = params.map{|x|"@#{x}"}.join ?,

    Class.new(MetaModule) do
      eval "def initialize(#{_params}); #{a_params} = #{_params} end"
      private; attr_reader *params
    end
  end
end


class My2 < MetaModule2.new :x, :y
  used do |target|
    target.check x
    target.check y
    target.check [x,y]
  end
  
  module Methods
    def check given
      p given
    end
  end
end

# module Context
#   extend My2.new 1, 2
# end

# class My < MetaModule
#   def initialize name
#     @name = name
#   end

#   used do |at|
#     at.abc @name
#   end

#   module Methods
#     def abc given; p given end
#   end
# end

# module A
#   extend My.new 123
# end
# include My.new 234