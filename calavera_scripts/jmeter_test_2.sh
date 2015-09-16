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
mkdir grafana
cd grafana
echo '<HTML><BODY><img src="http://formdevops1.upcnet.es:8022/graphite/render?target=stats.gauges.biz.calavera.brazos.cpu.*&from='"$START"'&until='"$END"'&format=png&maxDataPoints=1636&width=1588&height=121&bgcolor=1f1f1f&fgcolor=BBBFC2&lineWidth=1&hideLegend=false&yUnitSystem=si&lineMode=connected"></img></body></HTML>' > page1.html
