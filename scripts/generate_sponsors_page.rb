#!/usr/bin/env ruby

require 'csv'
require 'date'
require 'net/http'
require 'json'
require 'digest/md5'
require 'fileutils'
require 'tilt'
require 'erb'

CANONICAL_CSV = File.expand_path('../data/solnic-sponsorships-all-time.csv', __dir__)
CACHED_CSV = File.expand_path('../data/github-sponsors.csv', __dir__)
OUTPUT_FILE = File.expand_path('../content/github-sponsors/index.html', __dir__)
TEMPLATE_FILE = File.expand_path('../templates/github-sponsors.html.erb', __dir__)

# GitHub API token from environment
GITHUB_TOKEN = ENV['GITHUB_TOKEN']

class SponsorsTemplate
  include ERB::Util

  attr_reader :current_sponsors, :past_sponsors

  def initialize(current_sponsors, past_sponsors)
    @current_sponsors = current_sponsors
    @past_sponsors = past_sponsors
  end

  def github_profile_url(handle)
    "https://github.com/#{handle}"
  end

  def format_amount(amount)
    sprintf('$%.2f', amount)
  end
end

def fetch_github_avatar(username)
  return nil if username.nil? || username.empty?

  # Try user endpoint first
  user_uri = URI("https://api.github.com/users/#{username}")
  org_uri = URI("https://api.github.com/orgs/#{username}")

  [user_uri, org_uri].each do |uri|
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["Accept"] = "application/vnd.github.v3+json"
    request["Authorization"] = "token #{GITHUB_TOKEN}" if GITHUB_TOKEN

    response = http.request(request)
    body = JSON.parse(response.body) rescue nil

    if response.is_a?(Net::HTTPSuccess) && body && body['avatar_url']
      puts "Found avatar for #{username} at #{uri.path}"
      return body['avatar_url']
    else
      error_message = body && body['message'] ? body['message'] : response.message
      puts "Failed to fetch GitHub avatar for #{username} from #{uri.path}: #{response.code} - #{error_message}"
    end
  end

  nil
rescue => e
  puts "Error fetching GitHub avatar for #{username}: #{e.message}"
  nil
end

def fetch_gravatar(email)
  return nil if email.nil? || email.empty?

  hash = Digest::MD5.hexdigest(email.downcase)
  uri = URI("https://www.gravatar.com/avatar/#{hash}?s=100&d=404")

  response = Net::HTTP.get_response(uri)
  if response.is_a?(Net::HTTPSuccess)
    uri.to_s
  else
    nil
  end
rescue => e
  puts "Error fetching Gravatar for #{email}: #{e.message}"
  nil
end

def get_avatar_url(sponsor)
  return sponsor['avatar_url'] if sponsor['avatar_url'] && !sponsor['avatar_url'].empty?

  # Try GitHub first
  github_avatar = fetch_github_avatar(sponsor['sponsor_handle'])
  return github_avatar if github_avatar

  # Fallback to Gravatar
  gravatar = fetch_gravatar(sponsor['sponsor_email'])
  return gravatar if gravatar

  nil
end

def active_sponsor?(last_transaction_date)
  return false unless last_transaction_date

  # Consider active if last transaction was in the current or previous month
  transaction_date = Date.parse(last_transaction_date)
  current_date = Date.today

  transaction_month = transaction_date.strftime('%Y-%m')
  current_month = current_date.strftime('%Y-%m')
  previous_month = (current_date << 1).strftime('%Y-%m')

  [current_month, previous_month].include?(transaction_month)
end

unless GITHUB_TOKEN
  puts "Warning: GITHUB_TOKEN not set. GitHub API rate limits will be very restrictive."
end

# Read canonical CSV and build cached version
FileUtils.mkdir_p(File.dirname(CACHED_CSV))

canonical_data = CSV.read(CANONICAL_CSV, headers: true)
  .map { |row| row.to_h }
  .select { |s| s['Is Public?'].to_s.downcase == 'true' }
  .group_by { |s| s['Sponsor Handle'] }
  .map do |handle, transactions|
    latest = transactions.max_by { |t| Date.parse(t['Transaction Date']) }
    started_on = transactions.min_by { |t| Date.parse(t['Sponsorship Started On']) }['Sponsorship Started On']
    is_active = active_sponsor?(latest['Transaction Date'])

    {
      'sponsor_handle' => handle,
      'sponsor_name' => latest['Sponsor Profile Name'],
      'sponsor_email' => latest['Sponsor Public Email'],
      'monthly_amount' => latest['Tier Monthly Amount'],
      'last_transaction_date' => latest['Transaction Date'],
      'sponsorship_started_on' => started_on,
      'is_active' => is_active,
      'avatar_url' => nil
    }
  end

# Read existing cached data if available
cached_data = if File.exist?(CACHED_CSV)
  CSV.read(CACHED_CSV, headers: true).map { |row| row.to_h }
else
  []
end

# Update cached data
cached_by_handle = cached_data.group_by { |s| s['sponsor_handle'] }.transform_values(&:first)

updated_data = canonical_data.map do |sponsor|
  cached = cached_by_handle[sponsor['sponsor_handle']]

  if cached && cached['avatar_url']
    # Keep the cached avatar URL
    sponsor.merge('avatar_url' => cached['avatar_url'])
  else
    # Try to fetch a new avatar URL
    avatar_url = get_avatar_url(sponsor)
    if avatar_url
      puts "Found avatar for #{sponsor['sponsor_name']}: #{avatar_url}"
    else
      puts "No avatar found for #{sponsor['sponsor_name']}"
    end
    sponsor.merge('avatar_url' => avatar_url)
  end
end

# Write updated cached data
CSV.open(CACHED_CSV, 'w') do |csv|
  csv << updated_data.first.keys # headers
  updated_data.each { |row| csv << row.values }
end

# Process sponsors for the page
current_sponsors = updated_data
  .select { |s| s['is_active'] }
  .sort_by { |s| [Date.parse(s['sponsorship_started_on'])] }
  .reverse

past_sponsors = updated_data
  .reject { |s| s['is_active'] }
  .sort_by { |s| [Date.parse(s['sponsorship_started_on'])] }
  .reverse

# Render the template
template = Tilt.new(TEMPLATE_FILE)
content = template.render(SponsorsTemplate.new(current_sponsors, past_sponsors))

# Write the content
File.write(OUTPUT_FILE, content)
puts "Generated sponsors page at #{OUTPUT_FILE}"
puts "Updated sponsors cache at #{CACHED_CSV}"
