require'rubygems'
require'nokogiri'
require'open-uri'

module WordpressChangelog
  VERSION = "0.0.1"

  class WordpressVersion
  	def initialize(version, url)
  		@version 		= version
  		@url 			= url
  		@categories 	= Hash.new
  		@category_names = Hash.new
  		loadChangedCategories
  	end
	
	def loadChangedCategories
		page = Nokogiri::HTML(open(@url))
		page.css("#bodyContent > h3+ul").each{|list|
			category = list.previous_element;
			category_id = category.previous_element()['id']
			category_name = category.element_children[0].text
			category_name.strip!  
			@categories[category_id] = list.children()
			@category_names[category_id] = category_name
		}
	end
	def printCategory(cat)
		unless @categories[cat].nil?
			puts @categories[cat]
		end
	end

	def hasCategory?(cat)
		return !@categories[cat].nil?
	end

	def getCategory(cat)
		return @categories[cat]
	end

	def getCategories
		categories = Array.new
		@categories.each_key { |key|  categories.push(key)}
		return categories
	end
  end
end
