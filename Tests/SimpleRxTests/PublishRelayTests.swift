import XCTest
@testable import SimpleRx

final class PublishRelayTests: XCTestCase {
    func test_basic() {
        var c = 0
        let p = PublishRelay<Int>()
        let o = p.asObservable()
        o.subscribe { (v) in
            c += 1
            print("sub1: \(v)")
        }
        p.accept(0)
        XCTAssertEqual(c, 1)

        o.subscribe { (v) in
            c += 1
            print("sub2: \(v)")
        }
        p.accept(10)
        XCTAssertEqual(c, 3)
    }
    func test_deinit() {
        var c = 0
        var p: PublishRelay<Int>? = PublishRelay<Int>()
        p?.subscribe(onNext: { (v) in
            c += 1
            print("sub1: \(v)")
        })
        p?.accept(2)
        XCTAssertEqual(c, 1)
        p = nil
        p?.accept(3)
        XCTAssertEqual(c, 1)
    }
    func test_thread() {
        let exp = XCTestExpectation()
        XCTAssertTrue(Thread.isMainThread)
        var c = 0
        let p = PublishRelay<Int>()
        p.subscribe { (v) in
            c += 1
            XCTAssertTrue(Thread.isMainThread)
            exp.fulfill()
        }
        DispatchQueue.global(qos: .userInteractive).async {
            p.accept(0)
        }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(c, 1)
    }

    static var allTests = [
        ("testBasic", test_basic),
        ("testDeinit", test_deinit),
        ("testThread", test_thread),
    ]
}
