require 'spec_helper'

describe SimpleNavigationRenderers::InvalidHash do
  it "has specific default message" do
    subject.message.should == "Hash does not contain any of parameters: 'text', 'icon'"
  end
end
