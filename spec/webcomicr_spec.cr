require "./spec_helper"

it "correctly parses relative urls" do
  complete_url("https://example.org/image", "https://example.com/test").should eq("https://example.org/image")
  complete_url("/image", "https://example.com/test").should eq("https://example.com/image")
  complete_url("image", "https://example.com/test").should eq("https://example.com/test/image")
  complete_url("image", "https://example.com/?date=123").should eq("https://example.com/image")
end
