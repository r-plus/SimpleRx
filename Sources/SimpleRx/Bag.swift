struct BagKey: Equatable {
    fileprivate let rawValue: UInt64
}

struct Bag<T> {
    typealias Entry = (key: BagKey, value: T)
    private var _nextKey = BagKey(rawValue: 0)
    private var _pairs = ContiguousArray<Entry>()

    mutating func insert(_ element: T) -> BagKey {
        let key = _nextKey
        _nextKey = BagKey(rawValue: _nextKey.rawValue &+ 1)
        _pairs.append((key: key, value: element))
        return key
    }

    func forEach(_ action: (T) -> Void) {
        for entry in _pairs {
            action(entry.value)
        }
    }

    mutating func removeKey(_ key: BagKey) {
        for i in 0 ..< _pairs.count where _pairs[i].key == key {
            _pairs.remove(at: i)
            return
        }
    }
}
