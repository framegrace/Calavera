Known Errors
============

This is a recopilation of Known Errors, limitations and notable aspects of this Calavera fork

- 001 : calavera.build.sh crashes if you have previously run it and the dnsmasq docker image is already defined. *Workaround:* docker will fail stating the offending image id. Just run ``docker rm <offending_id>``

- 002 : Ports are not redirected to the host machine. No solution still provided

