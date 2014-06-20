require'rubygems'
require'nokogiri'
require'open-uri'

module WordpressChangelog
  VERSION = "0.0.2"

  class WordpressVersion
    def initialize(version, url)
      @version         = version
      @url             = url
      @categories     = Hash.new("")
      @category_names = Hash.new("")
      loadChangedCategories
    end

    def loadChangedCategories
      page = Nokogiri::HTML(open(@url))
      heading = nil
      page.css("#bodyContent > h3~ul, #bodyContent > h4~ul").each{|list|
        category = list.previous_element;
        if !category.nil? && (category.name == 'h4' || category.name == 'h3')
          heading = category
        end
        unless heading.nil?
          category_id = heading.previous_element()['id']
          category_id = category_id.gsub(/(_\d+)/, "") 
          category_name = heading.element_children[0].text
          category_name.strip!  
          @categories[category_id] += list.children().to_s.gsub(/<li>/, '<li data-version="'+@version+'">')
          @category_names[category_id] = category_name
        end

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

    def getCategoryNames
      return @category_names
    end

    def getCategories
      categories = Array.new
      @categories.each_key { |key|  categories.push(key)}
      return categories
    end
  end
end
