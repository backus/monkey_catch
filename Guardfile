require 'guard'

ignore(/tmp/, /doc/)

guard :bundler do
  watch('Gemfile')
  watch('*.gemspec')
end

group :documentation do
  guard :yardstick do
    watch(%r{^(lib\/(.+)\.rb)$}) { |m| m[0] }
  end

  # Critique documentation (visual help and recommendations)
  guard :inch do
    watch(/.+\.rb/)
  end
end

# Build documentation
guard :yard do
  watch(%r(app/.+\.rb))
  watch(%r(lib/.+\.rb))
  watch(%r(ext/.+\.c))
end

group :critique do
  # Critique code smells
  guard :reek, cli: %w(-c config/reek.yml), run_all_with: ['lib'] do
    watch(/.+\.rb$/) { 'lib' }
  end

  # Critique the most painful code
  guard :flog do
    watch(%r{^lib/(.+)\.rb$})

    # Rails example
    watch(%r{^app/(.+)\.rb$})
  end

  # Critique code for structural similarities
  guard :flay do
    watch(%r{^lib/(.+)\.rb$})

    # Rails example
    watch(%r{^app/(.+)\.rb$})
    watch(%r{^app/(.*)(\.erb|\.haml)$})
    watch('config/routes.rb')

    # Flay specs
    watch(%r{^spec/(.+)_spec\.rb$})
  end

  # Critique code style
  guard :rubocop, cli: %w(-c config/rubocop.yml) do
    watch(/(.+\.rb)$/) { |m| m[0] }
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end

# RSpec is often the longest running guard so we put it at the end
guard :rspec, cmd: 'bundle exec rspec --no-profile' do
  watch(%r{lib/(.*)\.rb\z}) { |m| Dir["spec/unit/#{m[1]}{,/**/*}_spec.rb"] }
  watch(%r{(spec/.*\.rb)\z}) { |m| m[0] }
end
