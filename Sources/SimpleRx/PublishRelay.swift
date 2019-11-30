import Foundation

public class PublishRelay<Element>: Observable<Element> {

    private var observers: [OnNextClosure] = []
    private let lock = NSRecursiveLock()

    public func accept(_ element: Element) {
        lock.lock()
        if Thread.isMainThread {
            for o in observers {
                o(element)
            }
            lock.unlock()
        } else {
            DispatchQueue.main.async {
                for o in self.observers {
                    o(element)
                }
                self.lock.unlock()
            }
        }
    }

    public override func subscribe(onNext next: @escaping OnNextClosure) {
        lock.lock(); defer { lock.unlock() }
        observers.append(next)
    }
}
