# Set root

set_root () {
  local relative_to_test=$1; shift
  local root=$(readlink -f $BATS_TEST_DIRNAME/$relative_to_test)
  cd $root
}

# Stub helpers

setup_stubs () {
  _stubs=()
  stub_path=$BATS_TMPDIR/bin
  mkdir -p $stub_path
}

teardown_stubs () {
  for s in "${_stubs[@]}"; do
    rm -f $stub_path/$s
    rm -f $stub_path/$s.result
  done
  rmdir $stub_path
}

_create_stub () {
  local name=$1; shift
  local content=$1; shift
  local path=$stub_path/$name

  _stubs=("${_stubs[@]}" $name)
  echo -e "$content" > "$path"
  chmod a+x $path
}

stub () {
  local name=$1; shift
  _create_stub "$name" "#!/bin/sh\n"
}

expect_stub () {
  local name=$1; shift
  _create_stub "$name" "#!/bin/sh\necho \"\$@\" >> $stub_path/$name.result\n"
}

expect () {
  local name=$1; shift
  local line=${1:-1}
  sed "${line}q;d" "$stub_path/$name.result"
}
