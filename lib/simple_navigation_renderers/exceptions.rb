module SimpleNavigationRenderers
  # Exception raised when you set Hash without both 'text' and 'icon' parameters as Item 'name' parameter 
  class InvalidHash < StandardError
    def initialize( msg = "Hash does not contain any of parameters: 'text', 'icon'" )
      super
    end
  end
end
