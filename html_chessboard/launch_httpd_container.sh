#!/bin/sh

_DOCKER=/usr/bin/docker
_ID=/usr/bin/id
_PWD=/bin/pwd

${_DOCKER} run \
	--interactive \
	--tty \
	--volume "$(${_PWD} --physical)/htdocs/:/usr/local/apache2/htdocs/" \
	--publish '8080:80' \
	--name 'apache_httpd' \
	--rm \
	httpd:latest

#	--user "$(${_ID} --user):$(${_ID} --group)" \
#	--env "APACHE_RUN_USER=#$(${_ID} --user)" \
#	--env "APACHE_RUN_GROUP=#$(${_ID} --group)" \

