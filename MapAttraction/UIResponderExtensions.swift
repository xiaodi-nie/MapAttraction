//
//  UIResponderExtensions.swift
//  MapAttraction
//
//  Created by codeplus on 11/7/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

import UIKit

private var firstResponderRef: UIResponder? = nil

extension UIResponder {
    static var firstResponder: UIResponder? {
        get {
            firstResponderRef = nil
            // The trick here is, that the selector will be invoked on the first responder
            UIApplication.shared.sendAction(#selector(setFirstResponderRef), to: nil, from: nil, for: nil)
            return firstResponderRef
        }
    }
    
    @objc private func setFirstResponderRef() {
        firstResponderRef = self
    }
}
