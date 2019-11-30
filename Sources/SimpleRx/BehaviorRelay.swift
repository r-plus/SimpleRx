import Foundation

public class BehaviorRelay<Element>: Observable<Element> {

    private var observers: [OnNextClosure] = []
    private let lock = NSRecursiveLock()
    public private(set) var value: Element

    init(value: Element) {
        self.value = value
    }

    public func accept(_ element: Element) {
        lock.lock(); defer { lock.unlock() }
        value = element
        if Thread.isMainThread {
            for o in observers {
                o(element)
            }
        } else {
            DispatchQueue.main.async {
                for o in self.observers {
                    o(element)
                }
            }
        }
    }

    public override func subscribe(onNext next: @escaping OnNextClosure) {
        lock.lock(); defer { lock.unlock() }
        observers.append(next)
        next(value)
    }
}

