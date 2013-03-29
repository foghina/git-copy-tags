#!/usr/bin/env ruby

def usage
  puts "Usage: git-copy-tags <source-repo> <dest-repo> [-f]"
  exit 1 
end

def get_tags
  tags = %x(git tag)
  tags_hsh = Hash.new

  tags.each_line do |tag|
    tag.strip!
    commit = %x(git rev-list --max-count=1 #{tag}).strip
    tags_hsh[tag] = commit
  end

  tags_hsh
end

# sanity check
if ARGV.length < 2
  usage
end

source = ARGV[0]
dest = ARGV[1]
force = ARGV[2] == "-f"

# dumb test to see if the args are actually git repos
unless File.directory? File.join(source, ".git")
  puts "FATAL: source directory doesn't exist, or is not a git repo"
  usage
end

unless File.directory? File.join(dest, ".git")
  puts "FATAL: destination directory doesn't exist, or is not a git repo"
  usage
end

# keep the old cwd
cwd = Dir.getwd

begin
  # get the tags from the source
  Dir.chdir(source)
  source_tags = get_tags

  # get the tags from the destination
  Dir.chdir(dest)
  dest_tags = get_tags

  unless force
    puts "Running dry, use -f to actually apply changes..."
  end
  source_tags.each do |tag, commit|
    unless dest_tags.has_key? tag or not system "git rev-list --max-count=1 #{commit} > /dev/null 2> /dev/null"
      if force
        if system "git tag #{tag} #{commit}"
          puts "Tagged #{commit} with #{tag}"
        else
          puts "Error while tagging #{commit} with #{tag}"
        end
      else
        puts "Would tag #{commit} with #{tag}"
      end
    end
  end
ensure
  Dir.chdir cwd
end