module SimpleNavigationRenderers

  module Bootstrap

    def render( item_container )
      if (skip_if_empty? && item_container.empty?)
        ''
      else
        list_content = with_bootstrap_configs do

          item_container.items.inject([]) do |list, item|
            li_options = item.html_options

            navbar_text = li_options.delete(:navbar_text)
            navbar_divider = li_options.delete(:divider)
            navbar_header = li_options.delete(:header)
            link_options = li_options.delete(:link) || {}
            split = li_options.delete(:split)

            if navbar_text
              list << li_text( item.name, li_options )
            elsif navbar_divider
              list << li_divider( item_container.level, li_options )
            elsif navbar_header && (item_container.level != 1)
              list << li_header( item.name, li_options )
            else
              li_content = if include_sub_navigation?(item)
                if item_container.level == 1
                  if split
                    main_li_options = li_options.dup
                    main_li_options[:class] = [ main_li_options[:class], "dropdown-split-left" ].flatten.compact.join(' ')
                    list << content_tag(:li, simple_link(item, link_options), main_li_options)
                    li_options[:id] = nil
                    item.sub_navigation.dom_class = [ item.sub_navigation.dom_class, "pull-right" ].flatten.compact.join(' ')
                  end
                  li_options[:class] = [ li_options[:class], "dropdown", (split ? "dropdown-split-right" : nil) ].flatten.compact.join(' ')
                  dropdown_link(item, split, link_options) + render_sub_navigation_for(item)
                else
                  li_options[:class] = [ li_options[:class], "dropdown-submenu"].flatten.compact.join(' ')
                  simple_link(item, link_options) + render_sub_navigation_for(item)
                end
              else
                simple_link(item, link_options)
              end
              list << content_tag(:li, li_content, li_options)
            end
          end.join

        end

        item_container.dom_class = [ item_container.dom_class,
                                     (item_container.level == 1) ? "nav#{(options[:bv] == 2) ? '' : ' navbar-nav'}" :
                                                                   "dropdown-menu" ].flatten.compact.join(' ')
        content_tag(:ul, list_content, {id: item_container.dom_id, class: item_container.dom_class})
      end
    end


    protected

      def li_text( text, li_options )
        content_tag(:li, content_tag(:p, text, {class: 'navbar-text'}), li_options)
      end

      def li_divider( level, li_options )
        li_options[:class] = [ li_options[:class], ((level == 1) ? "divider-vertical" : "divider") ].flatten.compact.join(' ')
        content_tag(:li, '', li_options)
      end

      def li_header( text, li_options )
        li_options[:class] = [ li_options[:class], ((options[:bv] == 2) ? "nav-header" : "dropdown-header") ].flatten.compact.join(' ')
        content_tag(:li, text, li_options)
      end

      def simple_link( item, link_options )
        link_options[:method] ||= item.method
        link_to(item.name, (item.url || "#"), link_options)
      end

      def dropdown_link( item, split, link_options )
        link_options = {} if split
        link_options[:class] = [ link_options[:class], "dropdown-toggle" ].flatten.compact.join(' ')
        link_options[:"data-toggle"] = "dropdown"
        link_options[:"data-target"] = "#"
        link = [ (split ? nil : item.name), content_tag(:b, '', class: "caret") ].compact.join(' ')
        link_to(link, "#", link_options)
      end

      def with_bootstrap_configs
        config_selected_class = SimpleNavigation.config.selected_class
        config_name_generator = SimpleNavigation.config.name_generator

        SimpleNavigation.config.selected_class = "active"
        # name_generator should be proc (not lambda or method) to be compatible with earlier versions of simple-navigation
        SimpleNavigation.config.name_generator = proc do | name, item |
          if name.instance_of?(Hash)
            raise SimpleNavigationRenderers::InvalidHash unless name.keys.include?(:icon) || name.keys.include?(:text)
            [ (name[:icon] ? content_tag(:span, '', {class: name[:icon]}.merge(name[:title] ? {title: name[:title]} : {}) ) : nil), name[:text] ].compact.join(' ')
          else
            config_name_generator.call( name, item )
          end
        end

        result = yield

        SimpleNavigation.config.name_generator = config_name_generator
        SimpleNavigation.config.selected_class = config_selected_class

        result
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
