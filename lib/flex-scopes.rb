require 'flex'
require 'flex/scope'
require 'flex/scopes'
require 'flex/result/scope'

Flex::LIB_PATHS << __FILE__.sub(/flex-scopes.rb$/, '')

Flex::Conf.result_extenders |= [Flex::Result::Scope]
