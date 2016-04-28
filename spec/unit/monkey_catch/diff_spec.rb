RSpec.describe MonkeyCatch::Diff do
  before do
    stub_const('Foo', Class.new(BasicObject))
    stub_const('Bar', Foo)
  end

  it 'asdf' do
    monkey_patch =
      lambda do
        class Foo
          def baz; end
        end
      end

    expect(described_class.call(monkey_patch, [Foo, Bar, Float::NAN])).to eql([
      MonkeyCatch::Method::Instance.new(
        klass:    Foo,
        name:     :baz,
        location: __FILE__,
        lineno:   11
      )
    ])
  end
end
