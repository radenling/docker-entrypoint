#!/usr/bin/env bats

load init_script_test_helper

@test "adduser should create a group" {
  stub adduser
  expect_stub addgroup
  PATH="$stub_path:$PATH" \
      CONTAINER_GID=1000 \
      CONTAINER_GROUP=mygroup \
      run sh ./entrypoint.d/10_adduser

  [ "$status" -eq 0 ]
  [ $(expect addgroup) = "-g 1000 mygroup" ]
}

@test "adduser should create a user" {
  stub addgroup
  expect_stub adduser
  PATH="$stub_path:$PATH" \
      CONTAINER_HOME=/user \
      CONTAINER_UID=1000 \
      CONTAINER_GROUP=mygroup \
      CONTAINER_USER=username \
      run sh ./entrypoint.d/10_adduser

  [ "$status" -eq 0 ]
  [ $(expect adduser) = "-s /sbin/nologin -h /user -D -u 1000 -G mygroup username" ]
}
