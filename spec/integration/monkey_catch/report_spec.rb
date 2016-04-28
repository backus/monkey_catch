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
    let(:report) do
      "Instance method monkey patch:  `Foo#bar`\n" \
      "Singleton method monkey patch: `Foo.baz`\n"
    end

    it 'detects new instance method' do
      expect do
        described_class.report do
          class Foo
            def self.baz; end
            def bar; end
          end
        end
      end.to output(report).to_stdout
    end
  end

  context 'core method defined on Object' do
    let(:report) { "Instance method monkey patch:  `Object#==`\n" }

    it 'Object#==' do
      expect do
        described_class.report do
          class Object
            def ==(*)
              super
            end
          end
        end
      end.to output(report).to_stdout
    end
  end

  context 'when module is included in kernel scope' do
    let(:file) { Pathname(__FILE__).join('../../../shared/examples/include_example.rb') }
    it 'detects monkey patch' do
      expect do
        described_class.report do
          load(file)
        end
      end.to output('').to_stdout
    end
  end
end
