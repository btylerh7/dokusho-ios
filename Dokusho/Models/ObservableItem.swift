//
//  ObservableObject.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/30/23.
//

import Foundation

final public class ObservableItem<T> {
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.value)
            }
        }
    }
    private var listener: ((T) -> Void)?
    
    
    init(_ value: T) {
        self.value = value
    }
    
    
    
    func bind( _ listener: @escaping ((T) -> Void)) {
        self.listener = listener
    }
}
