require "simple-navigation"
require "simple_navigation_renderers/exceptions"
require "simple_navigation_renderers/bootstrap"
require "simple_navigation_renderers/bootstrap_breadcrumbs"
require "simple_navigation_renderers/engine" if defined? Rails::Engine
require "simple_navigation_renderers/version"

module SimpleNavigationRenderers
end

SimpleNavigation.register_renderer( bootstrap2: SimpleNavigationRenderers::Bootstrap2 )
SimpleNavigation.register_renderer( bootstrap3: SimpleNavigationRenderers::Bootstrap3 )
SimpleNavigation.register_renderer( bootstrap_breadcrumbs2: SimpleNavigationRenderers::BootstrapBreadcrumbs2 )
SimpleNavigation.register_renderer( bootstrap_breadcrumbs3: SimpleNavigationRenderers::BootstrapBreadcrumbs3 )
