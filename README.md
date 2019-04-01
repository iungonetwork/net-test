# System tests

To setup test env consult docker-compose.yml from service-gateway repo. To run tests execute:
```
docker-compose run --rm -e ADD_AP=y -e ADD_USER=y -e KILL_AP=y test tests
```

You can mount contaner's /tmp dir to check the output of failed test, debug test or store test data.
Running with mounted /tmp dir and ADD_AP=y option will create /tmp/ap.json file with access point data.
This could be usefull to test with single AP (not creating new one on every run).

## Config params

Configure tests with env params:
- set `ADD_AP=y` to create new access point on run. This gets persisted to /tmp/ap.json that is used by subsequent tests,
- set `ADD_USER=y` to create new user on run. This gets persisted to /tmp/user.json that is used by subsequent tests.
- set `KILL_AP=y` to test AP kill function.

## Run single test

You can run single test, given ap.json and user.json exists in /tmp dir.
```
docker-compose run --rm -e ADD_AP=y -e ADD_USER=y -e KILL_AP=y test tests/21_access_point_radius.bats
```