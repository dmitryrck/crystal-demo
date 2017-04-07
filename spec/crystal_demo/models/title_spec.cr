require "../../spec_helper"

describe CrystalDemo::Title do
  context "#to_hash" do
    it "should always return a hash" do
      CrystalDemo::Title.new.to_hash.is_a?(Hash).should be_true
    end

    it "should include id" do
      title = CrystalDemo::Title.new
      title.id = 1

      title.to_hash.delete("id").should eq 1
    end

    it "should include title" do
      title = CrystalDemo::Title.new
      title.title = "Logan"

      title.to_hash.delete("title").should eq "Logan"
    end

    it "should include kind" do
      kind = CrystalDemo::KindType.new
      kind.id = 2
      kind.kind = "tv"

      title = CrystalDemo::Title.new
      title.kind_type = kind

      title.to_hash.delete("kind_type").should eq({ "name" => "tv", "id" => 2 })
    end
  end
end
