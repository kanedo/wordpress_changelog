require "wordpress_changelog/version"
require'rubygems'
require'nokogiri'
require'open-uri'

module WordpressChangelog
  class Changelog

  	def getCodexUrl
  		return "https://codex.wordpress.org"
  	end

  	def getVersionsUrl
  		return getCodexUrl+"/Category:Versions"
  	end

  	def initialize()
  		@versions = Hash.new
  		getVersions
  	end

  	def getVersions
  		page = Nokogiri::HTML(open(getVersionsUrl))
  		puts codex = getCodexUrl
  		puts page.css("a[title~='Version']").each { |link| 
  			version = /(\d\.?)+/.match(link['title'])[0] 
  			unless version.nil?
  				@versions["#{version}"] = "#{codex}#{link['href']}"
  			end
  		}
  	end

  	def showWordpressVersions
  		@versions.each { |key, val|  
  			puts "#{key}"
  		}
  	end
  	
  end
end
