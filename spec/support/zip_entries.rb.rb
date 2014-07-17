
def zip_entries file # to wrap this crap
  result = []  
  Zip::ZipFile.open file do |z|
    z.map do |entry|
      result << entry.name # !entry.file?
    end
  end
  result
end