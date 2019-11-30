public class Observable<Element> {

    public typealias OnNextClosure = (Element) -> Void

    public func subscribe(onNext next: @escaping OnNextClosure) {
        fatalError("please override")
    }

    public func asObservable() -> Observable<Element> {
        return self
    }
}
