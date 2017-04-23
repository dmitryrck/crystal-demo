require "../../spec_helper"

describe CrystalDemo::Name do
  context "validations" do
    it "should be valid" do
      name = CrystalDemo::Name.new
      name.name = "Jane Doe"
      name.md5sum = "abc"

      CrystalDemo::Name.changeset(name).valid?.should be_true
    end

    it "should not be valid without name" do
      name = CrystalDemo::Name.new
      name.md5sum = "abc"

      CrystalDemo::Name.changeset(name).valid?.should_not be_true
    end

    it "should not be valid with an empty name" do
      name = CrystalDemo::Name.new
      name.name = ""
      name.md5sum = "abc"

      CrystalDemo::Name.changeset(name).valid?.should_not be_true
    end
  end

  context "#to_hash" do
    it "should include id" do
      name = CrystalDemo::Name.new
      name.id = 1

      name.to_hash.delete("id").should eq 1
    end

    it "should include name" do
      name = CrystalDemo::Name.new
      name.name = "Logan"

      name.to_hash.delete("name").should eq "Logan"
    end

    it "should include md5sum" do
      name = CrystalDemo::Name.new
      name.md5sum = "abc"

      name.to_hash.delete("md5sum").should eq "abc"
    end
  end
end
