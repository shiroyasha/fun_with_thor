require "fun_with_thor/version"
require "thor"

class ThorNamespace < Thor
  def self.banner(command, namespace = nil, subcommand = false)
    "#{self.namespace}:#{command.formatted_usage(self, false, subcommand)}"
  end

  def self.help(shell, subcommand = false)
    list = printable_commands(true, subcommand)
    Thor::Util.thor_classes_in(self).each do |klass|
      list += klass.printable_commands(false)
    end

    list.sort! { |a, b| a[0] <=> b[0] }

    shell.say "Usage: fwt COMMAND"
    shell.say "Help topics, type fwt help TOPIC for more details: \n\n"

    shell.print_table(list, :indent => 2, :truncate => true)
    shell.say
    class_options_help(shell)
  end

  def self.printable_commands(all = true, subcommand = false)
    (all ? all_commands : commands).map do |_, command|
      next if command.hidden?
      item = []
      item << banner(command, true, false)
      item << (command.description ? "    #{command.description.gsub(/\s+/m, ' ')}" : "")
      item
    end.compact
  end
end

class TopLevelThor < Thor
  def self.banner(command, namespace = nil, subcommand = false)
    "#{command.formatted_usage(self, false, subcommand)}"
  end

  def self.help(shell, subcommand = false)
    shell.say "Usage: fwt COMMAND"
    shell.say
    shell.say "Help topics, type fwt help TOPIC for more details:"
    shell.say

    list = printable_commands(true, subcommand).reject { |cmd| cmd[0] =~ /help/ }

    shell.print_table(list, :indent => 2, :truncate => true)
    shell.say
  end
end

module FunWithThor

  class Greetings < ThorNamespace
    namespace :greetings

    desc "hello", "says hello"
    def hello
      puts "Hello"
    end

    desc "yo", "says yo", :banner => "dsadadasdas"
    def yo
      puts "yo"
    end

    desc "good_morning", "says yo", :banner => "dsadadasdas"
    def good_morning
      puts "Good Morning!"
    end
  end

  class Animals < Thor
    namespace :animals

    desc "cat", "does cat things"
    def cat
      puts "Nyago"
    end

    desc "dog", "does dog things"
    def cat
      puts "Woof"
    end

  end

  class CLI < TopLevelThor
    def self.start
      args = ARGV

      if args.size > 0
        if args[0] == "help"
          args = [args.shift] + args.shift.split(":") + args
        else
          args = args.shift.split(":") + args
        end
      end

      super(args)
    end

    desc "greetings", "Show various greetings"
    subcommand "greetings", FunWithThor::Greetings

    desc "animals", "Handle animals"
    subcommand "animals", FunWithThor::Animals
  end

end
