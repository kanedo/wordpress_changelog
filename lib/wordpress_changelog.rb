require'rubygems'
require'nokogiri'
require'open-uri'
require'set'
require "erb"
require 'terminal-table'

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

    def setOuputFile(file)
      @outputFile = file
    end

    def getVersions
      page = Nokogiri::HTML(open(getVersionsUrl))
      codex = getCodexUrl
      page.css("a[title~='Version']").each do |link| 
        version = /(\d\.?)+/.match(link['title'])[0] 
        @versions["#{version}"] = "#{codex}#{link['href']}" unless version.nil?
      end
    end

    def showWordpressVersions( pretty=true )
      if pretty
        rows = []
        @versions.keys.each_slice(8) do |version|
          rows << version
        end
        puts "Available Wordpress versions:"
        puts Terminal::Table.new :rows => rows, :style => {:border_x => "", :border_y => "", :border_i => ""}
      else
        @versions.each { |key, val|  puts "#{key}" }
      end
    end

    def changesBetween(versionA, versionB)
      if @versions["#{versionA}"].nil?
        puts "version #{versionA} does not exist"
        return nil
      end
      if  !versionB.nil? && versionA > versionB
        puts "version #{versionB} must be greater that #{versionA}"
        return nil
      end

      version_objects = Array.new
      categories = Set.new
      changes = Hash.new("")
      @categorie_names = Hash.new

      @versions.select { |key| (!versionB.nil? && key <= versionB && key >= versionA) || (key >= versionA && versionB.nil?)}.each do |v, url|
        version = WordpressVersion.new(v, url)

        @categorie_names.merge!(version.getCategoryNames)

        version.getCategories.each{|c| 
          categories.add(c)
        }
        version_objects.push(version)
      end

      categories.each do |e|  
        version_objects.each{|v|
          changes[e] += v.getCategory(e) if v.hasCategory?(e)
        }
      end
      changes.each{|key, change|
        changes[key] = change.gsub(/href="([^"]*)"/, 'href="'+getCodexUrl+'\1"')
      }
      return changes
    end

    def changes(versionA, versionB, format)
      versionB = getLatestVersion if versionB.nil?
      changes = changesBetween(versionA, versionB)
      outputHTML(changes, versionA, versionB)
    end

    def getLatestVersion
      @versions.keys.sort
      version = 0
      @versions.each_key{|v|
        version = v
      }
      return version
    end

    def outputHTML(changes, vA, vB)
      view = View.new(vA, vB, changes, getCodexUrl, @categorie_names)
      template_file = File.open(File.dirname(__FILE__) + ("/wordpress_changelog/templates/changes.erb") )
      renderer = ERB.new(template_file.read)
      result = renderer.result(view.get_binding)
      File.open(@outputFile, 'w') {|f| f.write(result) }
    end
  end
end
