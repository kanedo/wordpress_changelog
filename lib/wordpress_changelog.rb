require'rubygems'
require'nokogiri'
require'open-uri'
require'set'
require "erb"

require "wordpress_changelog/version"
require "wordpress_changelog/view"

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
  		codex = getCodexUrl
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
  	
    def changesBetween(versionA, versionB)
      if @versions["#{versionA}"].nil?
        puts "version #{versionA} does not exist"
        return nil
      end
      if  versionA > versionB
        puts "version #{versionB} must be greater that #{versionA}"
        return nil
      end
      version_objects = Array.new
      categories = Set.new
      changes = Hash.new("")
      @versions.select { |key| key <= versionB && key >= versionA }.each{|v, url|
          version = WordpressVersion.new(v, url)
          version.getCategories.each{|c| categories.add(c)}
          version_objects.push(version)
      }
      categories.each { |e|  
        version_objects.each{|v|
          if v.hasCategory?(e)
            changes[e] += v.getCategory(e).to_s
          end
        }
      }
      return changes
    end

    def changes(versionA, versionB, format)
      changes = changesBetween(versionA, versionB)
      outputHTML(changes, versionA, versionB)
    end

    def outputHTML(changes, vA, vB)
      view = View.new(vA, vB, changes)
      template_file = File.open(File.dirname(__FILE__) + ("/wordpress_changelog/templates/changes.erb") )
      renderer = ERB.new(template_file.read)
      result = renderer.result(view.get_binding)
      File.open("output.html", 'w') {|f| f.write(result) }
    end
  end
end
