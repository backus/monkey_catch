# Monkey Catch

Catch monkey patching!

```ruby
MonkeyCatch.report do
  class String
    def monkey_business
      puts 'woah!'
    end
  end
end

# => Instance method monkey patch:  `String#monkey_business`
```
