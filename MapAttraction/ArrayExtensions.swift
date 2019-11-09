//
//  ArrayExtensions.swift
//  MapAttraction
//
//  Created by codeplus on 11/8/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}
