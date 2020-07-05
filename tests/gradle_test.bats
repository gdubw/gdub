#!/usr/bin/env bats

load test_support

@test "gw::select_gradle" {
    run gw::select_gradle
    assert_failure
    [[ -z "${output}" ]]

    run gw::select_gradle ./resources
    assert_success
    assert_output -e ".*/resources/gradlew"
}