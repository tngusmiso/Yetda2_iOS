//
//  StoredData.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/12/14.
//

import Foundation

class StoredData {
    static let shared = StoredData()
    private init() { }
    
    var price: (Int, Int) = (0, 50_000_000) // (min, max)
    var tagList: [String] = []
}
