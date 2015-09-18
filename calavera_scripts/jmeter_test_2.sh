#!/bin/bash
echo "### Running JMeter performance test ###"

# Clear out old results
rm $WORKSPACE/jmeter.jtl

# Run the tests
echo "## Running the tests"
cd "$WORKSPACE/jmeter"

START=`date +%s`
jmeter -n -t jmeter_formdevops3.jmx -l $WORKSPACE/jmeter.jtl 
END=`date +%s`
echo "biz.calavera.hombros.tests.hijo.time:$(($END-$START))|ms"|nc -w 1 -u grafana 8125
