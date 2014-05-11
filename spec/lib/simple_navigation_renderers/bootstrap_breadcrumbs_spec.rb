require 'spec_helper'

describe SimpleNavigationRenderers::BootstrapBreadcrumbs do

  describe '.render' do

    # 'bv' is bootstrap version. Default is 3
    # 'selected_item' is option to choose selected item. Default is 3
    def render_result( bv=3, selected_item=3 )
      SimpleNavigation::Configuration.instance.renderer = (bv == 3) ? SimpleNavigationRenderers::BootstrapBreadcrumbs3
                                                                    : SimpleNavigationRenderers::BootstrapBreadcrumbs2

      SimpleNavigation.stub( adapter: (SimpleNavigation::Adapters::Rails.new(double(:context, view_context: ActionView::Base.new))) )

      SimpleNavigation::Item.any_instance.stub( selected_by_condition?: false )
      primary_navigation = SimpleNavigation::ItemContainer.new(1)
      fill_in( primary_navigation ) # helper method
      case selected_item
      when 1
        primary_navigation.items.find { |item| item.key == :news }
                                .stub( selected_by_condition?: true )
      when 2
        primary_navigation.items.find { |item| item.key == :info }.sub_navigation
                          .items.find { |item| item.key == :misc_info_pages }
                                .stub( selected_by_condition?: true )
      else
        primary_navigation.items.find { |item| item.key == :info }.sub_navigation
                          .items.find { |item| item.key == :misc_info_pages }.sub_navigation
                          .items.find { |item| item.key == :page2 }
                                .stub( selected_by_condition?: true )
      end

      HTML::Document.new( primary_navigation.render(expand_all: true) ).root
    end



    it "wraps breadcrumb nav in ol-tag with 'breadcrumb' class" do
      HTML::Selector.new('ol.breadcrumb').select(render_result).should have(1).entries
      HTML::Selector.new('ol.breadcrumb').select(render_result(2)).should have(1).entries
    end

    it "creates li-tag for each selected item (for each level)" do
      HTML::Selector.new('ol.breadcrumb > li').select(render_result).should have(3).entries
      HTML::Selector.new('ol.breadcrumb > li').select(render_result(2)).should have(3).entries
      HTML::Selector.new('ol.breadcrumb > li').select(render_result(3, 2)).should have(2).entries
      HTML::Selector.new('ol.breadcrumb > li').select(render_result(2, 2)).should have(2).entries
      HTML::Selector.new('ol.breadcrumb > li').select(render_result(3, 1)).should have(1).entries
      HTML::Selector.new('ol.breadcrumb > li').select(render_result(2, 1)).should have(1).entries
    end

    it "creates link-tag for each selected item except the last one (for each level except the deepest one)" do
      HTML::Selector.new('ol.breadcrumb > li > a').select(render_result).should have(2).entries
      HTML::Selector.new('ol.breadcrumb > li > a').select(render_result(2)).should have(2).entries
      HTML::Selector.new('ol.breadcrumb > li > a').select(render_result(3, 2)).should have(1).entries
      HTML::Selector.new('ol.breadcrumb > li > a').select(render_result(2, 2)).should have(1).entries
      HTML::Selector.new('ol.breadcrumb > li > a').select(render_result(3, 1)).should have(0).entries
      HTML::Selector.new('ol.breadcrumb > li > a').select(render_result(2, 1)).should have(0).entries
      HTML::Selector.new('ol.breadcrumb > li > a').select(render_result(3, 2))[0].children[0].to_s.should == '<span class="fa fa-fw fa-book" title="Info"></span>'
      HTML::Selector.new('ol.breadcrumb > li > a').select(render_result(2, 2))[0].children[0].to_s.should == '<span class="fa fa-fw fa-book" title="Info"></span>'
    end

    it "sets up 'active' class on the deepest selected item (on the last li-tag)" do
      HTML::Selector.new('ol.breadcrumb > li.active').select(render_result).should have(1).entries
      HTML::Selector.new('ol.breadcrumb > li.active').select(render_result(2)).should have(1).entries
      HTML::Selector.new('ol.breadcrumb > li.active').select(render_result)[0].children[0].to_s.should == "Page2"
      HTML::Selector.new('ol.breadcrumb > li.active').select(render_result(2))[0].children[0].to_s.should == "Page2"
    end

  end
end