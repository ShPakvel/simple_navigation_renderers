require 'spec_helper'
require 'html/document' unless defined? HTML::Document

describe SimpleNavigationRenderers::Bootstrap do

  describe '.render' do

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

    # 'bv' is bootstrap version
    # 'stub_name' neads to check raising error when invalid 'Item name hash' provided
    def render_result( bv=3, stub_name=false )
      SimpleNavigation::Configuration.instance.renderer = (bv == 3) ? SimpleNavigationRenderers::Bootstrap3 : SimpleNavigationRenderers::Bootstrap2

      SimpleNavigation.stub( adapter: (SimpleNavigation::Adapters::Rails.new(double(:context, view_context: ActionView::Base.new))) )

      SimpleNavigation::Item.any_instance.stub( selected?: false, selected_by_condition?: false )
      primary_navigation = SimpleNavigation::ItemContainer.new(1)
      fill_in( primary_navigation ) # helper method
      primary_navigation.items.find { |item| item.key == :news }.stub( selected?: true, selected_by_condition?: true )

      primary_navigation.items[0].instance_variable_set(:@name, {}) if stub_name

      HTML::Document.new( primary_navigation.render(expand_all: true) ).root
    end



    context "for 'bootstrap3' renderer" do
      it "wraps main menu in ul-tag with 'nav navbar-nav' classes" do
        HTML::Selector.new('ul.nav.navbar-nav').select(render_result).should have(1).entries
      end
    end

    context "for 'bootstrap2' renderer" do
      it "wraps main menu in ul-tag with 'nav' class" do
        HTML::Selector.new('ul.nav.navbar-nav').select(render_result(2)).should have(0).entries
        HTML::Selector.new('ul.nav').select(render_result(2)).should have(1).entries
      end
    end

    it "sets up 'active' class on selected items (on li-tags)" do
      HTML::Selector.new('ul.nav.navbar-nav > li.active > a[href="news_index_path"]').select(render_result).should have(1).entries
    end

    it "wraps submenu in ul-tag 'dropdown-menu' class" do
      HTML::Selector.new('ul > li > ul.dropdown-menu > li > ul.dropdown-menu').select(render_result).should have(1).entries
    end

    context "for the first level submenu (the second level menu)" do
      it "sets up 'dropdown' class on li-tag which contains that submenu" do
        HTML::Selector.new('ul > li.dropdown').select(render_result).should have(1).entries
      end

      it "sets up 'dropdown-toggle' class on link-tag which is used for toggle that submenu" do
        HTML::Selector.new('ul > li.dropdown > a.dropdown-toggle').select(render_result).should have(1).entries
      end

      it "sets up 'data-toggle' attribute to 'dropdown' on link-tag which is used for toggle that submenu" do
        HTML::Selector.new('ul > li.dropdown > a[data-toggle=dropdown]').select(render_result).should have(1).entries
      end

      it "sets up 'data-target' attribute to '#' on link-tag which is used for toggle that submenu" do
        HTML::Selector.new('ul > li.dropdown > a[data-target=#]').select(render_result).should have(1).entries
      end

      it "sets up 'href' attribute to '#' on link-tag which is used for toggle that submenu" do
        HTML::Selector.new('ul > li.dropdown > a[href=#]').select(render_result).should have(1).entries
      end

      it "puts b-tag with 'caret' class in li-tag which contains that submenu" do
        HTML::Selector.new('ul > li.dropdown > a[href=#] > b.caret').select(render_result).should have(1).entries
      end
    end

    context "for nested submenu (the third level menu and deeper)" do
      it "sets up 'dropdown-submenu' class on li-tag which contains that submenu" do
        HTML::Selector.new('ul > li > ul.dropdown-menu > li.dropdown-submenu').select(render_result).should have(1).entries
      end
    end



    context "when ':split' option provided" do
      context "for the first level item which contains submenu" do
        it "splits item on two li-tags (left and right) and right li-tag will contain the first level submenu (second level menu)" do
          HTML::Selector.new('ul > li.dropdown-split-left + li.dropdown.dropdown-split-right > ul.dropdown-menu').select(render_result).should have(1).entries
        end

        it "sets up 'pull-right' class on ul-tag which is the submenu" do
          HTML::Selector.new('ul > li > ul.dropdown-menu.pull-right').select(render_result).should have(1).entries
        end
      end

      context "for the second level item and deeper which contains submenu" do
        it "does not splits item on two li-tags" do
          HTML::Selector.new('ul.dropdown-menu > li.dropdown-split-left + li.dropdown.dropdown-split-right > ul.dropdown-menu').select(render_result).should have(0).entries
          HTML::Selector.new('ul.dropdown-menu > li.dropdown-submenu > ul.dropdown-menu').select(render_result).should have(1).entries
        end

        it "does not sets up 'pull-right' class on ul-tag which is the submenu" do
          HTML::Selector.new('ul.dropdown-menu > li > ul.dropdown-menu.pull-right').select(render_result).should have(0).entries
        end
      end

      context "for item which does not contain submenu" do
        it "does not splits item on two li-tags" do
          HTML::Selector.new('ul > li.to_check_split.dropdown-split-left + li.dropdown.dropdown-split-right').select(render_result).should have(0).entries
          HTML::Selector.new('ul > li.to_check_split').select(render_result).should have(1).entries
        end
      end
    end



    context "when ':navbar_text' option provided" do
      it "creates p-tag with class 'navbar-text' and item 'name' as a content instead of link-tag for the item (standard item)" do
        HTML::Selector.new('ul > li.to_check_navbar_text > a').select(render_result).should have(0).entries
        HTML::Selector.new('ul > li.to_check_navbar_text > a').select(render_result(2)).should have(0).entries
        HTML::Selector.new('ul > li.to_check_navbar_text > p.navbar-text').select(render_result)[0].children[0].to_s.should == "Signed in as Pavel Shpak"
        HTML::Selector.new('ul > li.to_check_navbar_text > p.navbar-text').select(render_result(2))[0].children[0].to_s.should == "Signed in as Pavel Shpak"
      end
    end



    context "when ':divider' option provided" do
      it "does not create link-tag for the item (standard item)" do
        HTML::Selector.new('ul > li.divider-vertical + li > a[href="divider_before_info_index_path"]').select(render_result).should have(0).entries
        HTML::Selector.new('ul.dropdown-menu > li.divider + li > a[href="divider_before_misc_info_pages"]').select(render_result).should have(0).entries
        HTML::Selector.new('ul.dropdown-menu > li.divider + li > a[href="divider_before_contact_info_page"]').select(render_result).should have(0).entries
      end

      context "for the first level item" do
        it "adds li-tag with class 'divider-vertical'" do
          HTML::Selector.new('ul > li.divider-vertical + li > a[href="info_index_path"]').select(render_result).should have(1).entries
        end
      end

      context "for the second level item and deeper" do
        it "adds li-tag with class 'divider'" do
          HTML::Selector.new('ul.dropdown-menu > li.divider + li > a[href="misc_info_pages"]').select(render_result).should have(1).entries
          HTML::Selector.new('ul.dropdown-menu > li.divider + li > a[href="contact_info_page"]').select(render_result).should have(1).entries
        end
      end
    end



    context "when ':header' option provided" do
      context "for the first level item" do
        it "does not set up 'dropdown-header' or 'nav-header' class on li-tag" do
          HTML::Selector.new('ul.nav.navbar-nav > li.to_check_header.dropdown-header').select(render_result).should have(0).entries
          HTML::Selector.new('ul.nav > li.to_check_header.nav-header').select(render_result(2)).should have(0).entries
        end

        it "creates link-tag for the item (standard item)" do
          HTML::Selector.new('ul.nav.navbar-nav > li.to_check_header > a').select(render_result).should have(1).entries
          HTML::Selector.new('ul.nav > li.to_check_header > a').select(render_result(2)).should have(1).entries
        end
      end

      context "for the second level item and deeper" do
        context "for 'bootstrap3' renderer" do
          it "sets up 'dropdown-header' class on li-tag" do
            HTML::Selector.new('ul.dropdown-menu > li.to_check_header2.dropdown-header').select(render_result).should have(1).entries
          end
        end

        context "for 'bootstrap2' renderer" do
          it "sets up 'nav-header' class on li-tag" do
            HTML::Selector.new('ul.dropdown-menu > li.to_check_header2.nav-header').select(render_result(2)).should have(1).entries
          end
        end

        it "does not create link-tag for the item (standard item), but puts only item 'name'" do
          HTML::Selector.new('ul.dropdown-menu > li.to_check_header2.dropdown-header > a').select(render_result).should have(0).entries
          HTML::Selector.new('ul.dropdown-menu > li.to_check_header2.nav-header > a').select(render_result(2)).should have(0).entries
          HTML::Selector.new('ul.dropdown-menu > li.to_check_header2.dropdown-header').select(render_result)[0].children[0].to_s.should == "Misc. Pages"
          HTML::Selector.new('ul.dropdown-menu > li.to_check_header2.nav-header').select(render_result(2))[0].children[0].to_s.should == "Misc. Pages"
        end
      end
    end



    context "when 'hash' provided in place of 'name'" do
      context "with ':icon' parameter" do
        it "adds span-tag with classes from the parameter" do
          HTML::Selector.new('ul > li > a > span.fa.fa-fw.fa-bullhorn').select(render_result).should have(1).entries
        end
      end

      context "with ':title' parameter" do
        it "sets up 'title' attribute on icon's span-tag to the parameter value" do
          HTML::Selector.new('ul > li > a > span.fa.fa-fw.fa-book[title="Info"]').select(render_result).should have(1).entries
        end
      end

      context "with ':text' parameter" do
        it "uses the parameter value as 'name' of the item" do
          HTML::Selector.new('ul > li > a > span.fa.fa-fw.fa-bullhorn').select(render_result)[0].parent.children[1].to_s.should == " News"
        end
      end

      context "without ':text' and ':icon' parameters" do
        it "raises 'InvalidHash' error" do
          expect {
            render_result(3, true)
          }.to raise_error( SimpleNavigationRenderers::InvalidHash )
        end
      end
    end

  end
end
