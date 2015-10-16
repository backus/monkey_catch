RSpec.describe MonkeyCatch, '.report' do
  before { stub_const('Foo', Class.new(BasicObject)) }

  around(:each) do |example|
    begin
      $stderr = StringIO.new
      example.run
    ensure
      $stderr = STDERR
    end
  end

  context 'non-core constant defined before report' do
    let(:report) { "Instance method monkey patch:  `Foo#bar`\n" }

    it 'detects new instance method' do
      expect do
        described_class.report do
          class Foo
            def bar; end
          end
        end
      end.to output(report).to_stdout
    end
  end

  context 'core method defined on Object' do
    let(:report) { "Instance method monkey patch:  `Object#method_missing`\n" }

    it 'Object.method_missing' do
      expect do
        described_class.report do
          class Object
            def method_missing(*args, &blk)
              super(*args, &blk)
            end
          end
        end
      end.to output(report).to_stdout
    end
  end
end
