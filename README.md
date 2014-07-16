# realZip

## Warning
This gem is currently under development. Please refrain from using it.

## Usage

```ruby
require 'real_zip'

# create zip file with given file structure and transfer files to the directory of your choice within the zip file

RealZip 'temp.zip', {dir1:[:f1,:f2],dir2:[:f3,{dir4:[:f4]}]}

# ensure it works
puts `unzip -l temp.zip | awk '{print $4}'`
===========================================
dir1/
dir2/
dir2/dir4/
dir1/f1
dir1/f2
dir2/f3
dir2/dir4/f4
```

## Installation

Add this line to your application's Gemfile:

    gem 'real_zip'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install real_zip

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Acknowledgement
This is software is built upon Alexander K's Fake_Zip gem.A hearty thanks to him for making it freely available.