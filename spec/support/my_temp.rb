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