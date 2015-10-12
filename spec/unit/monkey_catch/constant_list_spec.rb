RSpec.describe MonkeyCatch::ConstantList, '.lookup' do
  subject { described_class.lookup(root) }

  let(:root) { Foo }

  let(:constants) do
    [
      Foo,
      Foo::Bar,
      Foo::Baz,
      Foo::Baz::QUX
    ]
  end

  before do
    stub_const('Foo::Bar', Class.new)
    stub_const('Foo::Baz::QUX', Object.new)
  end

  it { should eql(described_class.new(Set.new(constants))) }
end
