import Foundation

public final class PublishRelay<Element>
    : Observable<Element>
    , SynchronizedUnsubscribeType {

    private var observers = Bag<OnNextClosure>()
    private let lock = NSRecursiveLock()

    public func accept(_ element: Element) {
        lock.lock()
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
        return SubscriptionDisposable(owner: self, key: key)
    }

    func synchronizedUnsubscribe(_ disposeKey: BagKey) {
        lock.lock(); defer { lock.unlock() }
        observers.removeKey(disposeKey)
    }
}
