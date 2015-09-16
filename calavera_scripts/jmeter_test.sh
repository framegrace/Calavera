#!/bin/bash
echo "### Running JMeter performance test ###"

# Clear out old results
rm $WORKSPACE/jmeter.jtl

# Run the tests
echo "## Running the tests"
cd "$WORKSPACE/jmeter"

jmeter -n -t jmeter_formdevops3.jmx -l $WORKSPACE/jmeter.jtl 
