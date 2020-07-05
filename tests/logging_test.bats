#!/usr/bin/env bats

load test_support

@test "logging" {
  run gw::__log__ "Test"
  assert_success
  assert [ -z "${output}" ]

  export GW_LOG_LEVEL=${GW_LOG_DEBUG_LEVEL}

  run gw::log::info "Test"
  assert_output "[Gdub][INFO] Test"

  run gw::log::debug "Test"
  assert_output "[Gdub][DEBUG] Test"

  run gw::log::warn "Test"
  assert_output "[Gdub][WARN] Test"

  run gw::log::err "Test"
  assert_output "[Gdub][ERROR] Test"

  export GW_LOG_LEVEL=${GW_LOG_NONE_LEVEL}
  run gw::log::err "Test"
  assert [ -z "${output}" ]
}