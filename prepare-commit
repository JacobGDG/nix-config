#!/usr/bin/env ruby

# bin/prepare-commit: Prepare a commit message using staged changes and LLM, following semantic commit guidelines.
#
# It allows the user to given optional context and generates a commit message that can be used directly in a git commit.
#
# Usage: prepare-commit --context

require 'optparse'
require 'tempfile'
require "open3"

COMMIT_TYPES = [
  'feat: A new feature',
  'fix: A bug fix',
  'docs: Documentation only changes',
  'style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)',
  'refactor: A code change that neither fixes a bug nor adds a feature',
  'perf: A code change that improves performance',
  'test: Adding missing or correcting existing tests',
  'chore: Changes to the build process or auxiliary tools and libraries such as documentation generation'
].freeze
PROMPT_FILE = "~/src/prompts/generate/commit-message.md"

def exit_error(message)
  puts "Error: #{message}"
  exit 1
end

def check_dependency(cmd)
  system("which #{cmd} > /dev/null 2>&1") || exit_error("Required command '#{cmd}' not found. Please install it before running this script.")
end

def staged_diff
  changes = `git diff --staged`.strip
  exit_error("No staged changes found. Please stage your changes before running this script.") if changes.empty?
  changes.split("\n")
end

def prompt_for_context
  puts "Please provide additional context for the commit message (or press Enter to skip):"
  gets.chomp
end

def prompt_for_type(types)
  # with fzf
  response = `echo "#{types.join("\n")}" | fzf --height=10 --border --prompt="Commit Type: "`.strip
end

def generate_full_prompt(base_prompt, context, commit_type, changes)
  full_prompt = base_prompt.dup
  full_prompt << "\n\nContext: #{context}" unless context.empty?
  full_prompt << "\n\nCommit Type: #{commit_type}" unless commit_type.empty?
  full_prompt << "\n\nStaged Changes:\n#{changes.join("\n")}"
  full_prompt
end

def read_prompt(file_path)
  full_path = File.expand_path(file_path)
  unless File.exist?(full_path)
    exit_error("Prompt file '#{full_path}' does not exist. Please create it before running this script.")
  end
  File.read(full_path).strip
end

def generate_commit_message(prompt)
  # Assuming `llm` is a command that takes a prompt and returns a generated message
  Tempfile.create(['commit_prompt', '.md']) do |file|
    file.write(prompt)
    file.flush
    # Call the LLM with the prompt
    cmd = "llm prompt -f #{file.path} -m gpt-4o"
    msg, _ = Open3.capture2(cmd)
    return msg.strip
  end
end

# === Main Script ===

# Step 1: Parse command-line options
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: prepare-commit [options]"
end.parse!

check_dependency('git')
check_dependency('llm')
check_dependency('fzf')

context = prompt_for_context
commit_type = prompt_for_type(COMMIT_TYPES)
base_prompt = read_prompt(PROMPT_FILE)

prompt = generate_full_prompt(base_prompt, context, commit_type, staged_diff)

commit_msg = generate_commit_message(prompt)

puts commit_msg
