module SimpleNavigationRenderers

  module Bootstrap

    def render( item_container )
      config_selected_class = SimpleNavigation.config.selected_class
      SimpleNavigation.config.selected_class = "active"
      @config_name_generator = SimpleNavigation.config.name_generator
      SimpleNavigation.config.name_generator = self.method(:name_generator)

      item_container.dom_class = [ item_container.dom_class,
                                   (item_container.level == 1) ? "nav#{(options[:bv] == 2) ? '' : ' navbar-nav'}" :
                                                                 "dropdown-menu" ].flatten.compact.join(' ')
      
      list_content = item_container.items.inject([]) do |list, item|
        li_options = item.html_options

        if li_options.delete(:divider)
          if (item_container.level != 1)
            list << content_tag(:li, '', {class: "divider"})
          else
            list << content_tag(:li, '', {class: "divider-vertical"})
          end
        end

        if li_options.delete(:header) && (item_container.level != 1)
          list << content_tag(:li, item.name, { class: ((options[:bv] == 2) ? "nav-header" : "dropdown-header") })
        else

          link_options = li_options.delete(:link) || {}
          split = li_options.delete(:split)
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

      SimpleNavigation.config.selected_class = config_selected_class
      SimpleNavigation.config.name_generator = @config_name_generator

      (skip_if_empty? && item_container.empty?) ? '' :
        content_tag(:ul, list_content, {id: item_container.dom_id, class: item_container.dom_class})
    end


    protected

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

      def name_generator( name )
        if name.instance_of?(Hash)
          raise SimpleNavigationRenderers::InvalidHash unless name.keys.include?(:icon) || name.keys.include?(:text)
          [ (name[:icon] ? content_tag(:span, '', {class: name[:icon]}.merge(name[:title] ? {title: name[:title]} : {}) ) : nil), name[:text] ].compact.join(' ')
        else
          @config_name_generator.call(name)
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
