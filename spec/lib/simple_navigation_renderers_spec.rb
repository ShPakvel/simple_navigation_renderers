require "spec_helper"

describe SimpleNavigationRenderers do
  it "registers 'bootstrap2' renderer" do
    SimpleNavigation.registered_renderers[:bootstrap2].should == SimpleNavigationRenderers::Bootstrap2
  end

  it "registers 'bootstrap3' renderer" do
    SimpleNavigation.registered_renderers[:bootstrap3].should == SimpleNavigationRenderers::Bootstrap3
  end

  it "registers 'bootstrap_breadcrumbs2' renderer" do
    SimpleNavigation.registered_renderers[:bootstrap_breadcrumbs2].should == SimpleNavigationRenderers::BootstrapBreadcrumbs2
  end

  it "registers 'bootstrap_breadcrumbs3' renderer" do
    SimpleNavigation.registered_renderers[:bootstrap_breadcrumbs3].should == SimpleNavigationRenderers::BootstrapBreadcrumbs3
  end
end
