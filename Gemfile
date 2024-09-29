# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "html-proofer", "~> 5.0", group: :test
gem "sass-embedded", "1.79.4" # Add this line

platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]
