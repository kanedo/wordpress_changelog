module WordpressChangelog
  class View
    def initialize(versionA, versionB, changes, codex, categories)
      @versionA = versionA
      @versionB = versionB
      @changes  = changes
      @codexURL = codex
      @categories = categories
    end
    def get_binding
      binding()
    end


  end
end