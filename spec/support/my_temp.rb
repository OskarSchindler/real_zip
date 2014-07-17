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


class MyTemp < MetaModule2.new :getter, :file
  used do |at|
    at.def_temp_file getter, file
  end

  module Methods
    def def_temp_file getter, file
      let(getter) { file }
      after(:each) { File.delete file if File.exist? file }
    end
  end
end


















__END__
# def initialize getter, file
#   @getter, @file = getter, file
# end


# def extended target
#   target.def_temp_file @getter, @file
# end

# def temp_file getter, file
#   let(getter) { file }
#   after(:each) { File.delete file if File.exist? file }
# end

# def self.extended target
#   target.instance_eval do
#   end
# end