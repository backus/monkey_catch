# Monkey Catch

Catch monkey patching!

```ruby
MonkeyCatch.call do
  class String
    def monkey_business
      puts 'woah!'
    end
  end
end

# => MonkeyCatch::MonkeyPatch: class `String` monkey patched with #monkey_business
```
