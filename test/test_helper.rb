$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# I have to load coveralls before I require my application
require 'coveralls'
Coveralls.wear!

require "simplecov"
SimpleCov.start

require 'loterias_caixa'
require 'minitest/autorun'
require "minitest/reporters"

Minitest::Reporters.use!
