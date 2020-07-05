#!/usr/bin/env bats

load test_support

@test "gw::file::abs" {
  run gw::file::abs "file_tt.sh"
  assert_failure
  assert_equal "${output}" "file_tt.sh"

  run gw::file::abs "file_test.sh"
  assert_success
  assert_output -e "^/.*/gdub/tests/file_test.sh$"

  run gw::file::abs "../LICENSE"
  assert_success
  assert_output -e "^/.*/gdub/LICENSE$"

}

@test "gw::file::lookup" {
  run gw::file::lookup LICENSE "${PWD}"
  assert_success
  assert_output -e "^/.*/gdub/LICENSE$"

  run gw::file::lookup 999_file_not_exist
  assert_failure
  assert [ -z "${output}"]
}