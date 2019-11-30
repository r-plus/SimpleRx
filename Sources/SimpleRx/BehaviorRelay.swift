import Foundation

public class BehaviorRelay<Element>: Observable<Element> {

    private var observers: [OnNextClosure] = []
    private let lock = NSRecursiveLock()
    private var element: Element

    init(value: Element) {
        element = value
    }

    public var value: Element {
        lock.lock(); defer { lock.unlock() }
        return element
    }

    public func accept(_ element: Element) {
        lock.lock()
        self.element = element
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
        next(value)
    }
}

