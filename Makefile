all: run

run:
	bundle exec rerun 'rackup -p 8080'
install:
	gem install bundler
	bundle install

.PHONY: all run install