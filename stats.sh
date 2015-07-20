#!/bin/bash
MINE_PREFIX=$1
[ ! -z $MINE_PREFIX ] && MINE_PREFIX="${MINE_PREFIX}."
export MINE_PREFIX
export HOSTPREFIX=`hostname -f|sed 's/^\([^.]\+\)\.\([^.]\+\)\.\([^.]\+\)/\3\.\2\.\1/g'`
dstat -clng --nocolor --noupdate --noheaders 5 |sed -n -u '/^[0-9, ]/p'|stdbuf -o0 sed 's/^ *\([^ ]\+\) \+\([^ ]\+\) \+\([^ ]\+\) \+\([^ ]\+\) \+\([^ ]\+\) \+\([^ ]\+\) *| *\([^ ]\+\) \+\([^ ]\+\) \+\([^ ]\+\) *| *\([^ ]\+\) \+\([^ ]\+\) *| *.*$/cpu.usr:\1|g\ncpu.sys:\2|g\ncpu.idl:\3|g\ncpu.wait:\4|g\nloadavg.1m:\7|g\nloadavg.5m:\8|g\nloadavg.15m:\9|g\nnet.recv:\10|g\nnet.send:\11|g/g'|while read METRIC
do
echo "${HOSTPREFIX}."${MINE_PREFIX}${METRIC}|nc -w 1 -u grafana 8125
done
