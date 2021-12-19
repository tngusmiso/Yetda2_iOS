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
    
    private var _price: (Int, Int) = (0, 5_000) // (min, max) 단위: 만원
    static var price: (Int, Int) {
        get { StoredData.shared._price }
        set { StoredData.shared._price = newValue }
    }
    
    private var _tags: Set<String> = []
    static var tags: [String] {
        StoredData.shared._tags.map { $0 }
    }
    
    static func resetAll() {
        StoredData.resetGenderTagsAndReverse(nil)
        StoredData.resetSeasonTagAndReverse(nil)
        StoredData.resetPrice()
    }
    static func resetPrice() {
        StoredData.price = (0, 5_000)
    }
    static func storeTag(_ tag: String) {
        StoredData.shared._tags.insert(tag)
    }
    static func removeTags(_ tags: [String]) {
        tags.forEach {
            StoredData.shared._tags.remove($0)
        }
    }
    static func removeAllTags() {
        StoredData.shared._tags.removeAll()
    }
    /// 질문 번복 > 계절 관련 태그 삭제 후 재설정
    static func resetSeasonTagAndReverse(_ newValue: String?) {
        StoredData.removeTags(["여름", "겨울"])
        switch newValue {
        case "여름":
            StoredData.storeTag("겨울")
        case "겨울":
            StoredData.storeTag("여름")
        default:
            break
        }
        
    }
    /// 질문 번복 > 성별 관련 태그 삭제 후 재설정
    static func resetGenderTagsAndReverse(_ newValue: String?) {
            StoredData.removeTags(["여성", "남성"])
        switch newValue {
        case "여성":
            StoredData.storeTag("남성")
        case "남성":
            StoredData.storeTag("여성")
        default:
            break
        }
    }
}
