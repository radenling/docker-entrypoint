#!/usr/bin/env bats

load init_script_test_helper

@test "su-exec should be called with user and command line" {
  expect_stub "su-exec"
  PATH="$stub_path:$PATH" \
      CONTAINER_USER=username \
      CONTAINER_COMMAND=cmdline \
      run sh ./entrypoint.d/99_suexec

  [ "$status" -eq 0 ]
  [ $(expect su-exec) = "username cmdline" ]
}
