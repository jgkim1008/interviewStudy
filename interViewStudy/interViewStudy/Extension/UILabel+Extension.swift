//
//  UILabel+Extension.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/21.
//

import Foundation
import UIKit

extension UILabel {
    static func makeLabel(font: UIFont.TextStyle , color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: font)
        label.textColor = color
        return label
    }
}
