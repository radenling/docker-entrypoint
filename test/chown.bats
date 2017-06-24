#!/usr/bin/env bats

load init_script_test_helper

@test "chown home directory to user:group" {
  expect_stub "chown"
  PATH="$stub_path:$PATH" \
      CONTAINER_USER=username \
      CONTAINER_GROUP=groupname \
      CONTAINER_HOME=/userhome \
      run sh ./entrypoint.d/20_chown

  [ "$status" -eq 0 ]
  [ $(expect chown) = "-R username:groupname /userhome" ]
}
