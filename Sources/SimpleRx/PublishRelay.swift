import Foundation

public final class PublishRelay<Element>: Observable<Element> {

    private var observers: [OnNextClosure] = []
    private let lock = NSRecursiveLock()

    public func accept(_ element: Element) {
        lock.lock()
        for o in observers {
            o(element)
        }
        lock.unlock()
    }

    public override func subscribe(onNext next: @escaping OnNextClosure) {
        lock.lock(); defer { lock.unlock() }
        observers.append(next)
    }
}
