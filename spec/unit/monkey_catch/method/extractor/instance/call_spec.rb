RSpec.describe MonkeyCatch::Method::Extractor::Instance, '.call' do
  subject { described_class.call(constants) }

  let(:klass) { Class.new { def baz; end } }

  # Fake version of `::Object`
  class FakeObject
    class String
    end

    NIL = ::NIL
  end

  context 'top level instance methods' do
    let(:constants)  { [FakeObject::String, FakeObject::NIL, FakeObject::Foo] }

    before do
      stub_const('FakeObject::Foo', klass)
      allow(FakeObject::Foo).to receive(:instance_methods).and_return([:baz])
    end

    it { should eql([FakeObject::Foo.instance_method(:baz)]) }
  end

  context 'instance methods in nested classes' do
    let(:constants) do
      [
        FakeObject::String,
        FakeObject::NIL,
        FakeObject::Foo,
        FakeObject::Foo::Bar
      ]
    end

    before do
      stub_const('FakeObject::Foo::Bar', klass)
      allow(FakeObject::Foo::Bar).to receive(:constants).and_return([])
      allow(FakeObject::Foo::Bar).to receive(:instance_methods).with(false).and_return([:baz])
    end

    it { should eql([FakeObject::Foo::Bar.instance_method(:baz)]) }
  end
end
