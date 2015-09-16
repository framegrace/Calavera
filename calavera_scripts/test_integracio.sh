#!/bin/bash
# El test d'integracio. Molt senzill, per ara.
echo "Test d'integració"
curl --silent "http://localhost:8080/MainServlet" | grep "This is a skeleton application"
RESULTAT=$?
[ $RESULTAT -eq 0 ] && echo "TOT BE" || echo "ALGO HA FALLAT"
exit $RESULTAT
