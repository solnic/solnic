#!/usr/bin/env ruby

require 'yaml'
require 'fileutils'
require 'date'

# Directory paths
HASHNODE_DIR = File.expand_path('../tmp/hashnode', __dir__)
HUGO_POSTS_DIR = File.expand_path('../content/posts', __dir__)

def slugify(title)
  title.downcase
       .gsub(/[^a-z0-9\s-]/, '')
       .gsub(/\s+/, '-')
       .gsub(/-+/, '-')
       .gsub(/^-|-$/, '')
end

def parse_hashnode_post(file_path)
  content = File.read(file_path)

  # Split front matter and content
  if content =~ /\A---\n(.*?)\n---\n(.*)/m
    front_matter = YAML.safe_load($1)
    post_content = $2

    # Parse the date
    date = DateTime.parse(front_matter['datePublished']).strftime('%Y-%m-%d')

    {
      title: front_matter['title'],
      date: date,
      tags: front_matter['tags']&.split(',')&.map(&:strip) || [],
      slug: front_matter['slug'],
      content: post_content.strip
    }
  else
    raise "Invalid post format in #{file_path}"
  end
end

def post_exists?(slug)
  Dir.exist?(File.join(HUGO_POSTS_DIR, slug))
end

def create_hugo_post(post_data)
  post_dir = File.join(HUGO_POSTS_DIR, post_data[:slug])
  FileUtils.mkdir_p(post_dir)

  # Create the front matter
  front_matter = {
    'title' => post_data[:title],
    'date' => post_data[:date],
    'tags' => post_data[:tags],
    'slug' => post_data[:slug],
    'aliases' => ["/#{post_data[:date].gsub('-', '/')}/#{post_data[:slug]}"]
  }

  # Write the post
  File.open(File.join(post_dir, 'index.md'), 'w') do |f|
    f.puts '---'
    f.puts front_matter.to_yaml
    f.puts '---'
    f.puts
    f.puts post_data[:content]
  end
end

# Main script
puts "Starting Hashnode post import..."

imported_count = 0
skipped_count = 0

Dir.glob(File.join(HASHNODE_DIR, '*.md')).each do |file|
  next if file.include?('README.md')

  begin
    post_data = parse_hashnode_post(file)

    if post_exists?(post_data[:slug])
      puts "Skipping existing post: #{post_data[:slug]}"
      skipped_count += 1
    else
      create_hugo_post(post_data)
      puts "Imported: #{post_data[:slug]}"
      imported_count += 1
    end
  rescue => e
    puts "Error processing #{file}: #{e.message}"
  end
end

puts "\nImport completed!"
puts "#{imported_count} posts imported"
puts "#{skipped_count} posts skipped (already exist)"
