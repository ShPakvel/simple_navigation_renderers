require "simple_navigation_renderers/rendered_item"

module SimpleNavigationRenderers

  module Bootstrap

    def render( item_container )
      if skip_if_empty? && item_container.empty?
        ''
      else
        list_content = with_bootstrap_configs do
          item_container.items.inject([]) do |list, item|
            list << SimpleNavigationRenderers::RenderedItem.new( self, item, item_container.level, options[:bv] ).to_s
          end.join
        end
        item_container.dom_class = [ item_container.dom_class, container_class(item_container.level) ].flatten.compact.join(' ')
        content_tag(:ul, list_content, {id: item_container.dom_id, class: item_container.dom_class})
      end
    end


    private

      def container_class( level )
        if level == 1
          "nav" + ((options[:bv] == 3) ? ' navbar-nav' : '')
        else
          "dropdown-menu"
        end
      end

      def with_bootstrap_configs
        sn_config = SimpleNavigation.config
        config_selected_class = sn_config.selected_class
        config_name_generator = sn_config.name_generator
        sn_config.selected_class = "active"
        # name_generator should be proc (not lambda or method) to be compatible with earlier versions of simple-navigation
        sn_config.name_generator = proc do | name, item |
          config_name_generator.call( prepare_name(name), item )
        end

        result = yield

        sn_config.name_generator = config_name_generator
        sn_config.selected_class = config_selected_class

        result
      end

      def prepare_name( name )
        if name.instance_of?(Hash)
          if name[:icon]
            icon_options = {class: name[:icon], title: name[:title]}.reject { |_, v| v.nil? }
            content_tag(:span, '', icon_options) + ' ' + (name[:text] || '')
          else
            name[:text] || (raise SimpleNavigationRenderers::InvalidHash)
          end
        else
          name
        end
      end

  end


  class Bootstrap2 < SimpleNavigation::Renderer::Base
    include SimpleNavigationRenderers::Bootstrap

    def initialize( options )
      super( options.merge!({bv: 2}) ) # add bootstrap version option
    end
  end

  class Bootstrap3 < SimpleNavigation::Renderer::Base
    include SimpleNavigationRenderers::Bootstrap

    def initialize( options )
      super( options.merge!({bv: 3}) ) # add bootstrap version option
    end
  end

end
