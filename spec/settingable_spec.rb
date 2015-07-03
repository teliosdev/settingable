# encoding: utf-8

require "spec_helper"
require "settingable"

describe Settingable do
  it "should have a VERSION constant" do
    expect(subject.const_get("VERSION")).to_not be_empty
  end
end
