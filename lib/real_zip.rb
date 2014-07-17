require "real_zip/version"

require 'yaml'
require 'forwardable'
require 'zip/zipfilesystem'

def RealZip file, structure
  RealZip.new file, structure
end

module RealZip

  ####################

  module Helpers
    extend self

    def traverse array_or_hash, path=[], &block
      given = array_or_hash
      case given
      when Hash
        given.each_pair do |k,v|
          block.call path+[k], :dir # entering directory
          traverse v,path+[k],&block
        end
      when Array then given.each { |x| traverse x,path,&block }
      else
        block.call path+[given], :file
      end
    end

    def collect_all(given)
      found = []
      traverse given do |x,y| found << [x,y] end
      found
    end
    def collect_only(given, kind)
      collect_all(given).map { |(name,type)| name if type == kind }.compact
    end    
    def files(given)
      collect_only(given, :file).map { |x| x.join ?/ }
    end
    def dirs(given)
      collect_only(given, :dir).map { |x| x.join ?/ }
    end     
  end 

  ####################

  class RealZip < Struct.new :file_structure  
    def save file
      File.delete file if File.exist? file
      Zip::ZipFile.open file, Zip::ZipFile::CREATE do |z|
        # first_dir = nil
        dirs(struct).each do |dir|
          first_dir = dir
          z.dir.mkdir(dir) unless z.file.exist? dir
        end

        hash =  struct 
        puts "hash => #{hash}"
        hash.each do |dir,file_arr|
          puts "directory ======> #{dir}"
          puts "file_array ======> #{file_arr.to_s}"
          
          new_files = files({dir => file_arr})
          puts "new files ======> #{new_files.to_s}"
          new_files.each_with_index do |file, index|
            puts "file ======> #{file}      index => #{index}"
            orignal_file_path = file_arr[index]
            puts "orignal_file_path ==========> #{orignal_file_path}"
            string  = File.open(orignal_file_path, 'r'){ |f| f.read }
            file_name = file.split('/').last
            new_file_name = ( files( {dir => [ "#{file_name}" ] } ) ).first
            puts "file_name ========> #{file_name}"
            z.file.open(new_file_name, "w") { |f| f.write string }
          end  
        end 


        # op1 = struct
        # # arr = op1.values.first
        # # op2 = files(op1)
        # # res = op1.to_s + " ==== " + op2.to_s
        # op2 = files(op1)
        # puts "files(op1) ========> #{op2}"
        # files(op1).each_with_index do |file,index|
        #   puts "file => #{file}"
        #   key = ( file.split("//").first ).to_sym
        #   puts "Key ====> #{key} "  
        #   arr = op1[key]
        #   puts "arr of file => #{arr.to_s}"
        #   file_path = arr[0]
        #   puts "file_path ======> #{file_path}"
        #   # file_path = arr[index]
        #   # FileUtils.cp("/home/raw/Code/prasad/zip.rake", file)
        #   string  = File.open(file_path, 'r'){ |f| f.read }
        #   puts "===== #{op1.to_s}"
        #   z.file.open(file, "w") { |f| f.write string }
        # end      
      end
    end

    def struct given=file_structure
      given.is_a?(String) ? YAML.load(given) : given
    end

    private

    extend Forwardable
    def_delegators Helpers, :files, :dirs   
  end

  def new file, structure
    RealZip.new(structure).save file
  end

  module_function :new  
end


__END__
# Other tests...

found = []
RealZip::Helpers.traverse( {a: [{a: 1, b: 2}, 3]}, &proc{ |x| found << x } )
found.map { |x| x.join ?/ } == ["a", "a/a", "a/a/1", "a/b", "a/b/2", "a/3"] or raise

RealZip::Helpers.files({a: [{a: 1, b: 2}, 3]}) == %w[ a/a/1  a/b/2  a/3 ] or raise


require 'yaml'

raise unless RealZip('empty_dir: []').contents == {'empty_dir' => []}
raise unless RealZip('dir: [file1, file2]').contents == {'dir' => ['file1','file2']}

tree = 'root_dir: [file1, file2, nested_dir: []]'
raise unless RealZip(tree).contents == {'root_dir' => ['file1','file2',{'nested_dir' => [] }]}

file_name = 'temp-test-Real.zip'
tree = 'root_dir: [file1, file2, nested_dir: [nested_file.any], empty_dir: []]'
RealZip(tree).save file_name

Zip::ZipFile.open file_name do |z|
  z.file.exist? 'root_dir/file1' or raise
  z.file.exist? 'root_dir/file2' or raise
  z.file.exist? 'root_dir/nested_dir/nested_file.any' or raise
  z.file.exist? 'root_dir/empty_dir' or raise # no empty dirs
end 
File.delete file_name