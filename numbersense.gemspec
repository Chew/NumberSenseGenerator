Gem::Specification.new do |s|
  s.name = 'numbersense'
  s.version = '0.1.0'
  s.date = '2018-08-05'
  s.summary = 'Generate a Number Sense test!'
  s.description = 'Generate a Number Sense test!'
  s.authors = ['Chewsterchew']
  s.email = 'chew@chew.pw'
  s.files = Dir['lib/**/*.rb']
  s.homepage = 'http://github.com/Chewsterchew/NumberSense'
  s.license = 'MIT'
  s.add_runtime_dependency 'roman-numerals', '~> 0.3.0'
  s.required_ruby_version = '>= 2.2.4'
end
