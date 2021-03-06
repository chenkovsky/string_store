require "./spec_helper"

describe StringStore do
  # TODO: Write tests

  it "works" do
    store = StringStore.new
    id = store.get_id "example"
    store.to_disk("store.bin")
    store = StringStore.from_disk("store.bin")
    store.get_id("example").should eq(id)
  end

  it "get string" do
    store = StringStore.new
    id = store.get_id "example"
    store["example"].should eq(id)
    expect_raises(Exception, "Cannot find \"example2\"") {
      store["example2"]
    }
  end
end
