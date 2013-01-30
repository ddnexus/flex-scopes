require 'flex'
require 'flex/scope'
require 'flex/scopes'
require 'flex/result/scope'

Flex::LIB_PATHS << File.dirname(__FILE__)

Flex::Conf.result_extenders |= [Flex::Result::Scope]
