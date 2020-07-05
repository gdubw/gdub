load test_support

@test "Bats Hanged" {
    GRADLEW="LICENSE" run gw::select_gradle "./resources"
}