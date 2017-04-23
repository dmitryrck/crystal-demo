require "../../spec_helper"

describe CrystalDemo::Title do
  context "validations" do
    it "should be valid" do
      title = CrystalDemo::Title.new
      title.title = "Ghost in the shell"
      title.kind_id = 1
      title.production_year = 2017

      CrystalDemo::Title.changeset(title).valid?.should be_true
    end

    it "should not be valid without production_year" do
      title = CrystalDemo::Title.new
      title.title = "Ghost in the shell"
      title.kind_id = 1

      CrystalDemo::Title.changeset(title).valid?.should_not be_true
    end

    it "should not be valid without title" do
      title = CrystalDemo::Title.new
      title.kind_id = 1
      title.production_year = 2017

      CrystalDemo::Title.changeset(title).valid?.should_not be_true
    end

    it "should not be valid with an empty title" do
      title = CrystalDemo::Title.new
      title.title = ""
      title.kind_id = 1
      title.production_year = 2017

      CrystalDemo::Title.changeset(title).valid?.should_not be_true
    end

    # The validation above only exists in database
    pending "should not be valid without kind_id" do
      title = CrystalDemo::Title.new
      title.title = "Ghost in the shell"
      title.production_year = 2017

      CrystalDemo::Title.changeset(title).valid?.should_not be_true
    end
  end

  context "#to_hash" do
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

    it "should include production_year" do
      title = CrystalDemo::Title.new
      title.production_year = 2017

      title.to_hash.delete("production_year").should eq 2017
    end

    it "should include kind" do
      kind = CrystalDemo::KindType.new
      kind.id = 2
      kind.kind = "tv"

      title = CrystalDemo::Title.new
      title.kind_type = kind

      title.to_hash.delete("kind").should eq({ "name" => "tv", "id" => 2 })
    end
  end
end
