source :rubygems

# Add dependencies required to use your gem here.
gem 'colorize', '~> 0.5'

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
	gem 'rdoc', '~> 3.12'
	gem 'bundler', '>= 1.0.0'
	gem 'jeweler', '~> 1.8.4'
	gem 'simplecov'
	gem 'yard'
	gem 'rspec'
	platforms :ruby do
		gem 'redcarpet'
	end
	platforms :jruby do
		gem 'kramdown'
	end
end
