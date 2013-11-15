require "simple-navigation"
require "simple_navigation_renderers/exceptions"
require "simple_navigation_renderers/bootstrap"
require "simple_navigation_renderers/engine"
require "simple_navigation_renderers/version"

module SimpleNavigationRenderers
end

SimpleNavigation.register_renderer :bootstrap2 => SimpleNavigationRenderers::Bootstrap2
SimpleNavigation.register_renderer :bootstrap3 => SimpleNavigationRenderers::Bootstrap3
