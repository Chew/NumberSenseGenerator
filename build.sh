echo 'Building NumberSense...'
gem build numbersense.gemspec
echo 'Built! Installing...'
gem install ./numbersense-0.1.0.gem
echo 'Installed! Run with: numbersense'
