module WordpressChangelog
	class View
		def initialize(versionA, versionB, changes)
			@versionA = versionA
			@versionB = versionB
			@changes  = changes
		end
		def get_binding
			binding()
		end

		
	end
end