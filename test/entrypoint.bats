#!/usr/bin/env bats

load test_helper

fixture () {
  echo "$BATS_TEST_DIRNAME/fixtures/$1"
}

setup () {
  set_root ..
}

@test "entrypoint.sh loads all scripts in order" {
  fixture_root=$(fixture run_scripts)
  ENTRYPOINT_DIR="$fixture_root" run ./entrypoint.sh /bin/true

  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "first" ]
  [ "${lines[1]}" = "second" ]
  [ "${lines[2]}" = "third" ]
}

@test "entrypoint.sh does nothing without scripts" {
  fixture_root=$(fixture no_scripts)
  ENTRYPOINT_DIR="$fixture_root" run ./entrypoint.sh echo "cmdline"

  [ "$status" -eq 0 ]
  [ "$output" = "" ]
}

@test "entrypoint.sh should pass along environment to subscripts" {
  fixture_root=$(fixture args_script)
  ENTRYPOINT_DIR="$fixture_root" CONTAINER_UID=1000 run ./entrypoint.sh /bin/true

  [ "$status" -eq 0 ]
  [ "$output" = "1000" ]
}

@test "entrypoint.sh should export container variables" {
  fixture_root=$(fixture env_script)
  ENTRYPOINT_DIR="$fixture_root" CONTAINER_HOME=/etc run ./entrypoint.sh /bin/true with --some --args

  [ "${lines[0]}" = "env" ]
  [ "${lines[1]}" = "container" ]
  [ "${lines[2]}" = "container" ]
  [ "${lines[3]}" = "8000" ]
  [ "${lines[4]}" = "8000" ]
  [ "${lines[5]}" = "/etc" ]
  [ "${lines[6]}" = "/bin/true with --some --args" ]
}
