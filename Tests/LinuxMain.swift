import XCTest

import SimpleRxTests

var tests = [XCTestCaseEntry]()
tests += PublishRelayTests.allTests()
tests += BehaviorRelayTests.allTests()
XCTMain(tests)
