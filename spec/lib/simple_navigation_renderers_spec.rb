require "spec_helper"

describe SimpleNavigationRenderers do
  it "register 'bootstrap2' renderer" do
    SimpleNavigation.registered_renderers[:bootstrap2].should == SimpleNavigationRenderers::Bootstrap2
  end

  it "register 'bootstrap3' renderer" do
    SimpleNavigation.registered_renderers[:bootstrap3].should == SimpleNavigationRenderers::Bootstrap3
  end
end
