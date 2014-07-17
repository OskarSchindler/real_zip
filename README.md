# RealZip

## Usage

```ruby
require 'real_zip'

# create zip file with given file structure and transfer files to the directory of your choice within the zip file.


## Use Cases

RealZip 'temp.zip', {:html => ["/home/Files/a.html"], :pdf => ["/home/Files/c.pdf"], :rb => ["/home/Files/b.rb"]}

# Results in
puts `unzip -l temp.zip | awk '{print $4}'`
===========================================

html/
pdf/
rb/
html/a.html
pdf/c.pdf
rb/b.rb

RealZip 'temp.zip', {'doc/html' => ["/home/Files/a.html"], 'doc/pdf' => ["/home/Files/c.pdf"], 'doc/pdf/rb' => ["/home/Files/b.rb"]}

# Results in
puts `unzip -l temp.zip | awk '{print $4}'`
===========================================
doc/html/
doc/pdf/
doc/pdf/rb/
doc/html/a.html
doc/pdf/c.pdf
doc/pdf/rb/b.rb
```


## Installation

Add this line to your application's Gemfile:

    gem 'real_zip'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install real_zip

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Acknowledgement
This software is built upon [Alexander K](https://github.com/sowcow)'s [Fake_Zip](https://github.com/sowcow/fake_zip) gem. A hearty thanks to him for making it freely available. This project would not be possible without [Ravi Baghele](https://github.com/rbaghele)'s major input in implementing the core file tranfer functionality.I would also like to thank <a href="https://github.com/indermishra">Indrajeet Mishra</a> for his valuable insights about testing and debugging the gem.Our team leader <a href ="https://github.com/stormfire">Mr. Pankaj Gupta</a> has provided invaluable support and guidance throughout the project.

