RSpec.describe MonkeyCatch, '.report' do
  subject { described_class.report(constants) }

  before { Foo = Class.new }

  it 'reports new method being defined' do
    expect do
      described_class.report do
        class Foo
          def self.bar; end
          def bar; end
        end
      end
    end.to output(
      "Instance method monkey patch:  `Foo#bar`\n" \
      "Singleton method monkey patch: `Foo.bar`\n"
    ).to_stdout
  end
end
