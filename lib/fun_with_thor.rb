require "fun_with_thor/version"
require "thor"

module FunWithThor
  class CLI < Thor

    desc "hello", "says hello"
    def hello
      puts "Hello"
    end

  end
end
