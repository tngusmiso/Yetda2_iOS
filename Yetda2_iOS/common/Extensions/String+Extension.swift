//
//  String+Extension.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/12/16.
//

import Foundation

extension String {
    var reversedGender: String? {
        switch self {
        case "여성":
            return "남성"
        case "남성":
            return "여성"
        default:
            return nil
        }
    }
    var reversedSeason: String? {
        switch self {
        case "겨울":
            return "여름"
        case "여름":
            return "겨울"
        default:
            return nil
        }
    }
}
