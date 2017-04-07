require "../../spec_helper"

describe CrystalDemo::KindType do
  context "#to_hash" do
    it "should always return a hash" do
      CrystalDemo::KindType.new.to_hash.is_a?(Hash).should be_true
    end

    it "should include id" do
      title = CrystalDemo::KindType.new
      title.id = 1

      title.to_hash.delete("id").should eq 1
    end

    it "should include kind" do
      title = CrystalDemo::KindType.new
      title.kind = "concert"

      title.to_hash.delete("name").should eq "concert"
    end
  end
end
