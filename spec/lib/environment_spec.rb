describe Environment do

  before do
    @config = {
        test: {
          foo: 123,
          bar: 'abc'
        },
        production: {
          foo: 567,
          moo: "adb",
          apple: 'nah'
        },
        apple: 'yeah'
    }
  end

  it 'should return the top level property if it is present with no key specific environment' do
    Environment.new(:test, @config).apple.should == 'yeah'
  end

  it 'should return the more specific property if present' do
    Environment.new(:production, @config).apple.should == 'nah'
  end

  it 'should let you access a property within the key' do
    Environment.new(:test, @config).foo.should == 123
  end

  it 'should let you override at runtime' do
    env = Environment.new(:production, @config)
    env.apple = 'over'
    env.apple.should == 'over'
  end

end