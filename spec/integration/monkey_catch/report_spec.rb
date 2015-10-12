RSpec.describe MonkeyCatch, '.report' do
  before { stub_const('Foo', Class.new) }

  around(:each) do |example|
    begin
      $stderr = StringIO.new
      example.run
    ensure
      $stderr = STDERR
    end
  end

  it 'detects new instance method' do
    expect do
      described_class.report do
        class Foo
          def bar; end
        end
      end
    end.to output("Foo#bar\n").to_stdout
  end

  it 'Object.method_missing' do
    expect do
      described_class.report do
        class Object
          def method_missing(*args, &blk)
            super(*args, &blk)
          end
        end
      end
    end.to output("Object#method_missing\n").to_stdout
  end
end
