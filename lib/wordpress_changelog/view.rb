module WordpressChangelog
	class View
		def initialize(versionA, versionB, changes, codex)
			@versionA = versionA
			@versionB = versionB
			@changes  = changes
			@codexURL = codex
		end
		def get_binding
			binding()
		end

		
	end
end