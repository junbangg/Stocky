//
//  IdentifiableView.swift
//  Stocky
//
//  Created by Jun Bang on 2022/01/21.
//

import Foundation

protocol IdentifiableView {
    static var identifier: String { get }
}

extension IdentifiableView {
    static var identifier: String {
        return String(describing: self)
    }
}
