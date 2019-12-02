import Foundation

public final class BehaviorRelay<Element>
    : Observable<Element>
    , SynchronizedUnsubscribeType {

    private var observers = Bag<OnNextClosure>()
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
            observers.forEach { $0(element) }
            lock.unlock()
        } else {
            DispatchQueue.main.async {
                self.observers.forEach { $0(element) }
                self.lock.unlock()
            }
        }
    }

    public override func subscribe(onNext next: @escaping OnNextClosure) -> Disposable {
        lock.lock(); defer { lock.unlock() }
        let key = observers.insert(next)
        next(value)
        return SubscriptionDisposable(owner: self, key: key)
    }
    
    func synchronizedUnsubscribe(_ disposeKey: BagKey) {
        lock.lock(); defer { lock.unlock() }
        observers.removeKey(disposeKey)
    }
}

