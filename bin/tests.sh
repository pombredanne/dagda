#!/bin/bash -e

BASEDIR=`dirname $0`/..

echo "Testing on python system: `python3 --version`"
TEST_DIR=${BASEDIR}/env-test

echo "$TEST_DIR"
if [ ! -d "$TEST_DIR" ]; then
    python3 -m venv $TEST_DIR
    echo "New virtualenv for UT created."

    source $TEST_DIR/bin/activate
    echo "New virtualenv for UT activated."
    pip install -r $BASEDIR/requirements.txt
    pip install requests-mock==1.2.0
    pip install pytest-cov
fi

py.test --cov-report term:skip-covered --cov=dagda tests/

# Clean up all processes in the current process group
list_orphans ()
{
    local orphans=$(ps -ef | grep 'py.test --cov-report term:skip-covered --cov=dagda tests/' |
                    grep -v 'grep' | awk '{print $2}')

    echo "$orphans"
}

kill $(list_orphans)