import XCTest
@testable import SimpleRx

final class PublishRelayTests: XCTestCase {
    func test_basic() {
        var c = 0
        let p = PublishRelay<Int>()
        let o = p.asObservable()
        _ = o.subscribe { (v) in
            c += 1
            print("sub1: \(v)")
        }
        p.accept(0)
        XCTAssertEqual(c, 1)

        _ = o.subscribe { (v) in
            c += 1
            print("sub2: \(v)")
        }
        p.accept(10)
        XCTAssertEqual(c, 3)
    }
    func test_deinit() {
        var c = 0
        var p: PublishRelay<Int>? = PublishRelay<Int>()
        _ = p?.subscribe(onNext: { (v) in
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
        _ = p.subscribe { (v) in
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
    func test_dispose() {
        var c = 0
        let p = PublishRelay<Int>()
        let sub1 = p.subscribe(onNext: { (v) in
            c += 1
            print("sub1: \(v)")
        })
        p.accept(2)
        XCTAssertEqual(c, 1)
        let sub2 = p.subscribe(onNext: { (v) in
            c += 2
            print("sub2: \(v)")
        })
        p.accept(3)
        XCTAssertEqual(c, 4)
        sub1.dispose()
        p.accept(4)
        XCTAssertEqual(c, 6)
        sub2.dispose()
        p.accept(5)
        XCTAssertEqual(c, 6)
    }

    static var allTests = [
        ("testBasic", test_basic),
        ("testDeinit", test_deinit),
        ("testThread", test_thread),
        ("testDispose", test_dispose),
    ]
}
