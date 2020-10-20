test:
	bundle exec rake

setup:
	bin/setup

yard:
	bundle exec rake yard
	bundle exec rake yard-server

push:
	find . -maxdepth 1 -name '*.gem' -exec rm {} \;
	gem build *.gemspec
	gem push *.gem
