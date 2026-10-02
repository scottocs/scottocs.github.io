#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

# Prefer Homebrew Ruby to the older Ruby bundled with macOS.
for ruby_bin in /opt/homebrew/opt/ruby@3.3/bin /usr/local/opt/ruby@3.3/bin /opt/homebrew/opt/ruby/bin /usr/local/opt/ruby/bin; do
  if [ -x "$ruby_bin/ruby" ]; then
    export PATH="$ruby_bin:$PATH"
    break
  fi
done

if ! ruby -e 'exit(Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.1") ? 0 : 1)' 2>/dev/null; then
  echo 'Please install Ruby first: brew install ruby@3.3'
  exit 1
fi

bundle config set --local path vendor/bundle
if [ ! -f Gemfile.lock ] || ! bundle check; then
  bundle install
fi

echo
echo 'Preview: http://127.0.0.1:4000'
echo 'Keep this window open. Press Ctrl+C to stop.'
exec bundle exec jekyll serve --livereload --host 127.0.0.1 --port 4000
