describe FakeZip do
  extend MyTemp.new(:temp, 'tmp/testing.zip')

  describe '.new' do
    it 'takes file name and yaml string' do
      expect { FakeZip temp, '{}' }.to change { File.exist? temp }.from(false).to(true)
    end

    it 'takes file name and hash' do
      expect { FakeZip temp, {} }.to change { File.exist? temp }.from(false).to(true)
    end

    it 'recreates file if exist' do
      FakeZip temp, {dir:[:file]}
      FakeZip temp, {other:[:any]}
      zip_entries(temp).should == %w[ other/ other/any ]
    end
  end

  describe 'examples (given structure --- files in archive)' do
    examples = <<-END.lines.map(&:strip).map { |x| x.split(' --- ',2).map { |x| eval x } }
      "[]"       --- []
      {}         --- []
      {root: []} --- ['root/']
      "root: []" --- ['root/']
      'root_dir: [file1, file2, nested_dir: [nested_file.any], empty_dir: []]' ---  ["root_dir/", "root_dir/nested_dir/", "root_dir/empty_dir/", "root_dir/file1", "root_dir/file2", "root_dir/nested_dir/nested_file.any"] 
    END

    examples.each do |input,output|
      specify "#{input.inspect} --- #{output.inspect}" do
        FakeZip temp, input
        zip_entries(temp).should == output
      end
    end
  end
end