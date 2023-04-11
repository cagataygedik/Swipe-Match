//
//  Bindable.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 11.04.2023.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?)->())?
    
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
    
}
