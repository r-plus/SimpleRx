import XCTest
@testable import SimpleRx

final class BehaviorRelayTests: XCTestCase {
    func test_basic() {
        var c = 0
        let p = BehaviorRelay<Int>(value: 10)
        XCTAssertEqual(p.value, 10)
        _ = p.subscribe { (v) in
            c += 1
            print("sub1: \(v)")
        }
        p.accept(20)
        XCTAssertEqual(p.value, 20)
        XCTAssertEqual(c, 2)

        _ = p.subscribe { (v) in
            c += 1
            print("sub2: \(v)")
        }
        p.accept(30)
        XCTAssertEqual(p.value, 30)
        XCTAssertEqual(c, 5)
    }
    func test_deinit() {
        var c = 0
        var p: BehaviorRelay<Int>? = BehaviorRelay<Int>(value: 10)
        _ = p?.subscribe(onNext: { (v) in
            c += 1
            print("sub1: \(v)")
        })
        p?.accept(20)
        XCTAssertEqual(c, 2)
        p = nil
        p?.accept(30)
        XCTAssertEqual(c, 2)
    }

    static var allTests = [
        ("testBasic", test_basic),
        ("testDeinit", test_deinit),
    ]
}
