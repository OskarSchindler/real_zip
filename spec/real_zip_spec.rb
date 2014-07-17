describe RealZip do
  extend MyTemp.new(:temp, 'tmp/testing.zip')

  
    it 'takes file name and hash' do
      expect { RealZip temp, {} }.to change { File.exist? temp }.from(false).to(true)
    end
   
end