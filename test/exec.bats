#!/usr/bin/env bats

load init_script_test_helper

@test "exec should execute the command line" {
  PATH="$stub_path:$PATH" \
      CONTAINER_COMMAND="echo success" \
      run sh ./entrypoint.d/99_exec

  [ "$status" -eq 0 ]
  [ "$output" = "success" ]
}
