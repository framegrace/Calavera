#!/bin/bash
for NODE in cerebro manos brazos hombros cara espina
do
  scp stats.sh root@${NODE}:/usr/bin
  ssh root@${NODE} "chmod a+x /usr/bin/stats.sh"
  ssh root@${NODE} "apt-get install -y dstat"
  ssh root@${NODE} 'killall stats.sh'
  ssh root@${NODE} 'nohup /usr/bin/stats.sh > stats.out 2> stats.err < /dev/null &'
done
