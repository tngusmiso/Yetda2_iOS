//
//  Array+Extension.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2022/11/27.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
