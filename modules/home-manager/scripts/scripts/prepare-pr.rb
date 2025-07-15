#!/usr/bin/env ruby

# prepare-pr.rb
# A script to pull all the commits that will be part of the PR and construct an easy to read description that will aid in code review

require 'optparse'
require 'tempfile'
require "open3"

PROMPT_FILE = "{{PULL_REQUEST_PROMPT}}".freeze

def check_dependency(cmd)
  system("which #{cmd} > /dev/null 2>&1") || exit_error("Required command '#{cmd}' not found. Please install it before running this script.")
end

def exit_error(message)
  puts "Error: #{message}"
  exit 1
end

def check_repo
  unless system("git rev-parse --is-inside-work-tree > /dev/null 2>&1")
    exit_error("This script must be run inside a git repository. Please navigate to your git repo and try again.")
  end
end

def current_branch
  `git rev-parse --abbrev-ref HEAD`.strip
end

def default_branch
  @default_branch ||= `git remote show origin | sed -n '/HEAD branch/s/.*: //p'`.strip
end

def any_changes?
  git_status = `git status`.strip
  !git_status.include? "nothing to commit"
end

def prepare_branch
  if current_branch == default_branch
    exit_error("You are on the default branch. Checkout a new one with `git co -b <branch_name>`")
  end

  if any_changes?
    exit_error("You have uncommited changes. Commit or stash those first.")
  end

  puts "Should I attempt a rebase? [y/n]"
  rebase_response = gets.chomp

  if %w[y Y yes].include? rebase_response
    `git pull origin #{default_branch} --rebase`
  end

  if commits.empty?
    exit_error("No commits found between #{default_branch} and #{current_branch}. Please ensure you have made commits before running this script.")
  end
end

def commits
  @commits ||= `git log #{default_branch}..#{current_branch}`.strip
end

def prompt_for_information(prompt)
  puts "#{prompt} (or press Enter to skip):"
  gets.chomp
end

def read_prompt(file_path)
  full_path = File.expand_path(file_path)
  unless File.exist?(full_path)
    exit_error("Prompt file '#{full_path}' does not exist. Please create it before running this script.")
  end
  File.read(full_path).strip
end

def generate_full_prompt(base_prompt, context, ticket_url, commit_log)
  full_prompt = base_prompt.dup
  full_prompt << "\n\nTicket URL: #{ticket_url}" unless ticket_url.empty?
  full_prompt << "\n\nContext: #{context}" unless context.empty?
  full_prompt << "\n\nCommit Log:\n```diff\n#{commit_log}\n```"
  full_prompt
end

def generate_pr_message(prompt)
  Tempfile.create(['commit_prompt', '.md']) do |file|
    file.write(prompt)
    file.flush
    cmd = "llm prompt -f #{file.path} -m gpt-4o"
    msg, _ = Open3.capture2(cmd)
    return msg.strip
  end
end

## RUNTIME

options = {}
ticket_url = ""
context = ""

OptionParser.new do |opts|
  opts.banner = "Usage: prepare-commit [options]"
  opts.on("-q", "--quick", "Skip asking for additional information") do
    options[:quick] = true
  end
  opts.on("-p", "--prompt-file FILE", "Path to the prompt file") do |file|
    options[:prompt_file] = file
  end
end.parse!

check_dependency('git')
check_dependency('llm')

check_repo

prepare_branch

unless options[:quick]
  ticket_url = prompt_for_information("Link to Ticket URL")
  context = prompt_for_information("Please provide additional context for the Pull Request")
end

base_prompt = read_prompt(options[:prompt_file] || PROMPT_FILE)
prompt = generate_full_prompt(base_prompt, context, ticket_url, commits)

commit_msg = generate_pr_message(prompt)

puts commit_msg
