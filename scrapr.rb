#!/usr/bin/env ruby

# dependencies
require 'open-uri'
require 'nokogiri'
require 'json'

# data storage object
class Job
	def initialize(title, company, url)
		@title = title
		@company = company
		@url = url
	end

	def to_s
		@title + ", " + @company + " (" + @url + ")"
	end

	def to_json
		hash = {:title => @title, :company => @company, :url => @url}
		JSON.generate(hash)
	end
end

# parse url
url = "https://remoteok.io"
doc = Nokogiri::HTML(open(url))

# search keywords
jobs = doc.xpath("//tr[contains(@data-search, 'digital nomad')]")

# extract data into Job instances
jobs = jobs.map do |job|
	title = job.xpath("td[contains(@class, 'company_and_position_mobile')]/a[contains(@class, 'preventLink')]/h2/text()").text
	company = job.xpath("td[contains(@class, 'company_and_position_mobile')]/a[contains(@class, 'preventLink')]/h3/text()").text
	posturl = url + job.attr("data-url")
	Job.new(title.to_s, company.to_s, posturl.to_s)
end

# output string
jobs.each {|j| puts j}

# output json
# jobs.each {|j| puts j.to_json}