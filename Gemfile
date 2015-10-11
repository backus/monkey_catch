source 'https://rubygems.org'

gemspec

gem 'pry'
gem 'pry-byebug'

group :test do
  gem 'rspec', '~> 3'
  gem 'rspec-its', '~> 1'
  gem 'codeclimate-test-reporter'

  # If you have to support older versions of ruby then include these verison
  # specific platforms here.  If you do not, then just change it to `mri`. If
  # the build still fails due to one of these platforms then please remove it
  # and update this boilerplate gemfile.
  platform :mri_21, :mri_22 do
    gem 'devtools', github: 'blockscore/devtools'
  end
end

group :guard do
  # Filewatcher and runner
  gem 'guard', '~> 2.12.4'

  # Autorun documentation critic
  gem 'guard-inch', '~> 0.1'

  # Autogen docs
  gem 'guard-yard', '~> 2.1'

  # My fork of guard-yardstick which makes the keywords more prominent
  gem 'guard-yardstick', github: 'backus/guard-yardstick', branch: 'color'

  # Autorun style critic
  gem 'guard-rubocop', '~> 1.2'

  gem 'rubocop-rspec', '~> 1.3', github: 'nevir/rubocop-rspec'

  # Autorun codesmell critic
  gem 'guard-reek', '= 0.0.3', github: 'backus/guard-reek'

  # Autorun similar code critic
  gem 'guard-flay', '= 0.0.3', github: 'backus/guard-flay'

  # Autorun painful code critic
  gem 'guard-flog', '= 0.0.4', github: 'backus/guard-flog'

  # Autorun specs
  gem 'guard-rspec', '~> 4.6'

  # rebundle
  gem 'guard-bundler', '~> 2.1'
end
