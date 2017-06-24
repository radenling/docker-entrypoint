#!/usr/bin/env bats

load init_script_test_helper

@test "moduser should modify user uid and gid based on name" {
  expect_stub "sed"
  PATH="$stub_path:$PATH" \
      CONTAINER_USER=username \
      CONTAINER_GROUP=groupname \
      CONTAINER_UID=1234 \
      CONTAINER_GID=4567 \
      run sh ./entrypoint.d/10_moduser

  [ "$status" -eq 0 ]
  [ $(expect sed 1) = "-i s/username:\([^:]*\)\(:[^:]\+\)\{2\}/username:\1:1234:4567/ /etc/passwd" ]
  [ $(expect sed 2) = "-i s/groupname:.*/groupname:x:4567:/ /etc/group" ]
}
