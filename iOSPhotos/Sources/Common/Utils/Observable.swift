//
//  Observable.swift
//  iOSPhotos
//
//  Created by Chan on 8/28/24.
//

class Observable<T> {
    var value: T {
        didSet {
            listeners.forEach { $0(value) }
        }
    }

    private var listeners: [(T) -> Void] = []

    init(_ value: T) {
        self.value = value
    }

    func bind(_ listener: @escaping (T) -> Void) {
        listeners.append(listener)
        listener(value)
    }
}
