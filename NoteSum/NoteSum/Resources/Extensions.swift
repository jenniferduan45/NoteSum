//
//  Extensions.swift
//  NoteSum
//
//  Created by Yuxuan Wu on 3/26/23.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
