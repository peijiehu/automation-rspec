#!/bin/sh

# clean up before running
rm reports/*.jtl
rm reports/*.jmx

# print out env variables which will be used for ruby script
echo THREAD_COUNT = ${THREAD_COUNT}
echo LOOP_COUNT = ${LOOP_COUNT}
echo RAMPUP_TIME = ${RAMPUP_TIME}
echo SERVER_ENV = ${SERVER_ENV}

# run tests
# report will be generated as reports/perf_result_#{Time.now}.jtl
ruby perf/testplan.rb

export PERF_RESULT_FILE=reports/perf_result_*.jtl
# change permission of jtl file
chmod +x ${PERF_RESULT_FILE}

export GRAPH_FILE=reports/$(${PERF_RESULT_FILE%%.*}).png

# generate graph with report file
java $JMETER_HOME/lib/ext/CMDRunner.jar \
--tool Reporter \
--input-jtl ${PERF_RESULT_FILE} \
--generate-png ${GRAPH_FILE} \
--plugin-type ResponseTimesOverTime \
--width 800 \
--height 600