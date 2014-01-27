class TestObservableClass
  include Event::Observable
end

module Event

  describe Observable do

    it "should let you create and trigger an event" do
      observable = TestObservableClass.new
      observable.trigger(:drive, 'woo')

      value = nil
      observable.on(:drive) { |x| value = x }
      observable.trigger(:drive, 'yeah')

      value.should == 'yeah'
    end

    it "should let you attach multiple events" do
      observable = TestObservableClass.new

      a = []

      observable.on(:drive) { a << 'apple' }
      observable.on(:drive) { a << 'banana' }
      observable.trigger(:drive)

      a.should == ['apple', 'banana']
    end

    it "should work with callable objects" do
      name = nil
      observer = Proc.new { |x| name = x }

      observable = TestObservableClass.new
      observable.on(:drive, observer)

      observable.trigger(:drive, "abc")

      name.should == "abc"
    end

    it 'should not add duplicate observers' do
      a = []

      observer = Proc.new { a << 'foo' }

      observable = TestObservableClass.new

      observable.on(:drive, observer)
      observable.on(:drive, observer)

      observable.trigger(:drive)

      a.should == ['foo']
    end

    it "should allow you to off" do
      name = nil

      observer = Proc.new { |x| name = x}

      observable = TestObservableClass.new
      observable.on(:drive, observer)
      observable.off(:drive, observer)

      observable.trigger(:drive, "abc")

      name.should == nil
    end

    it "should allow you to off a block" do
      name = nil


      observable = TestObservableClass.new
      observer = observable.on(:drive) { |x| name = x }
      observable.off(:drive, observer)

      observable.trigger(:drive, "abc")

      name.should == nil
    end

    it 'should allow a single shot when observer' do
      a = []

      observable = TestObservableClass.new
      observer = observable.when(:drive) { |x| a << x }

      observable.trigger(:drive, 'abc')
      observable.trigger(:drive, 'efg')

      a.should == ['abc']
    end

    it 'should allow you to unsubscribe from a single shot observer' do
      a = []

      observable = TestObservableClass.new
      observer = observable.when(:drive) { |x| a << x }
      observable.off(:drive, observer)

      observable.trigger(:drive, 'abc')

      a.should == []
    end

  end

end