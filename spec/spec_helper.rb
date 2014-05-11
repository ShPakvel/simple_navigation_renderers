require 'coveralls'
require 'action_controller'
require "action_view/vendor/html-scanner"

Coveralls.wear!

unless defined?(Rails)
  module ::Rails
    module VERSION
      MAJOR = 4
    end
    def self.root; './'; end
    def self.env; 'test'; end

    class Railtie
      def self.initializer(*args); end
    end
  end
end

require "simple_navigation_renderers"

# tested navigation content
def fill_in( primary )
  primary.item :news, {icon: "fa fa-fw fa-bullhorn", text: "News"}, "news_index_path"
  primary.item :concerts, "Concerts", "concerts_path", class: "to_check_header", header: true
  primary.item :video, "Video", "videos_path", class: "to_check_split", split: true
  primary.item :divider_before_info_index_path, '#', divider: true
  primary.item :info, {icon: "fa fa-fw fa-book", title: "Info"}, "info_index_path", split: true do |info_nav|
    info_nav.item :main_info_page, "Main info page", "main_info_page"
    info_nav.item :about_info_page, "About", "about_info_page"
    info_nav.item :divider_before_misc_info_pages, '#', divider: true
    info_nav.item :misc_info_pages, "Misc.", "misc_info_pages", split: true do |misc_nav|
      misc_nav.item :header_misc_pages, "Misc. Pages", class: "to_check_header2", header: true
      misc_nav.item :page1, "Page1", "page1"
      misc_nav.item :page2, "Page2", "page2"
    end
    info_nav.item :divider_before_contact_info_page, '#', divider: true
    info_nav.item :contact_info_page, "Contact", "contact_info_page"
  end
  primary.item :singed_in, "Signed in as Pavel Shpak", class: "to_check_navbar_text", navbar_text: true
end
