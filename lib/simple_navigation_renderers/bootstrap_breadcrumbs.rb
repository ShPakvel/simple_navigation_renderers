module SimpleNavigationRenderers

  module BootstrapBreadcrumbs

    def render( item_container )
      if skip_if_empty? && item_container.empty? && !item_container.selected?
        ''
      else
        list_content = with_bootstrap_configs { li_tags( item_container ).join }
        item_container.dom_class = [ item_container.dom_class, "breadcrumb" ].flatten.compact.join(' ')
        content_tag(:ol, list_content, {id: item_container.dom_id, class: item_container.dom_class})
      end
    end

  protected

    def li_tags( item_container )
      list = []
      selected_item = item_container.selected_item
      if selected_by_subnav?( selected_item )
        list << link_tag( selected_item )
        list.concat li_tags( selected_item.sub_navigation )
      else
        list << text_tag( selected_item )
      end
      list
    end

    def selected_by_subnav?( item )
      item.sub_navigation && item.sub_navigation.selected?
    end

    def link_tag( item )
      link_options = item.html_options.delete(:link) || {}
      link_options[:method] ||= item.method
      link = link_to(item.name, (item.url || "#"), link_options.except(:class, :id))
      content_tag(:li, link + divider, item.html_options.except(:class, :id, :split))
    end

    def text_tag( item )
      content_tag(:li, item.name, {class: 'active'})
    end

    def with_bootstrap_configs
      sn_config = SimpleNavigation.config
      config_name_generator = sn_config.name_generator
      # name_generator should be proc (not lambda or method) to be compatible with earlier versions of simple-navigation
      sn_config.name_generator = proc do | name, item |
        config_name_generator.call( prepare_name(name), item )
      end

      result = yield

      sn_config.name_generator = config_name_generator

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


  class BootstrapBreadcrumbs2 < SimpleNavigation::Renderer::Base
    include SimpleNavigationRenderers::BootstrapBreadcrumbs

  protected

    def divider
      @divider ||= content_tag(:span, (options[:join_with] || '/'), class: 'divider')
    end
  end

  class BootstrapBreadcrumbs3 < SimpleNavigation::Renderer::Base
    include SimpleNavigationRenderers::BootstrapBreadcrumbs

  protected

    def divider
      @divider ||= ''
    end
  end

end
