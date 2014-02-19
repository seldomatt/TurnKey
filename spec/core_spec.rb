describe "Core" do

  before do
    class ToBeArchived;attr_accessor :name, :obj_ref;end
    class OtherObject;attr_accessor :name;end
    class ToBeArchived2;attr_accessor :name, :obj_ref;end
    class OtherObject2;attr_accessor :name;end
    class Adaptive; attr_accessor :name; def doSomething; @something = true; end; end
    @object_ref = OtherObject.new.tap{|o| o.name = "Referenced Object"}
    @object_ref2 = OtherObject2.new.tap{|o| o.name = "Referenced Object"}
    @to_be_archived = ToBeArchived.new.tap{|tba| tba.name = "Archived";tba.obj_ref = @object_ref}
    @adaptive = Adaptive.new.tap{|tba| tba.name = "Archived"; tba.doSomething }
  end

  describe "#archive" do

    it "should take an instance and key and save object to NSUserDefaults under specified key" do
      Turnkey.archive(@to_be_archived, "Archived-Object-Key")
      data = NSUserDefaults.standardUserDefaults["Archived-Object-Key"]
      un_archived = NSKeyedUnarchiver.unarchiveObjectWithData(data)
      un_archived.name.should == "Archived"
      un_archived.obj_ref.name.should == "Referenced Object"
    end

    it "should take a single instance or an array of objects" do
      objects_array = 5.times.map do
        ToBeArchived2.new.tap{|tba| tba.name = "Foo";tba.obj_ref = @object_ref2}
      end
      Turnkey.archive(objects_array, "Array-of-archived-objs")
      data = NSUserDefaults.standardUserDefaults["Array-of-archived-objs"]
      un_archived = NSKeyedUnarchiver.unarchiveObjectWithData(data)
      un_archived.length.should == 5
      first_obj = un_archived.first
      first_obj.name.should == "Foo"
      first_obj.obj_ref.class.should == OtherObject2
    end
  end

  describe "#unarchive" do

    it "should unarchive object when passed identifier key" do
      Turnkey.archive(@to_be_archived, "TBA")
      unarched = Turnkey.unarchive("TBA")
      unarched.name.should == "Archived"
      unarched.obj_ref.name.should == "Referenced Object"
      unarched.class.should == ToBeArchived
    end

    it "should unarchive object when passed identifier key and handle instance variables that have no accessor methods" do
      Turnkey.archive(@adaptive, "TBA1")
      unarched = Turnkey.unarchive("TBA1")
      unarched.name.should == "Archived"
      unarched.class.should == Adaptive
    end
  end
end