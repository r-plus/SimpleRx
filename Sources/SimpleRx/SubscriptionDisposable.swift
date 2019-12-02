protocol SynchronizedUnsubscribeType: AnyObject {
    func synchronizedUnsubscribe(_ disposeKey: BagKey)
}

struct SubscriptionDisposable<T: SynchronizedUnsubscribeType>: Disposable {
    private let key: BagKey
    private weak var owner: T?

    init(owner: T, key: BagKey) {
        self.owner = owner
        self.key = key
    }

    func dispose() {
        owner?.synchronizedUnsubscribe(key)
    }
}
