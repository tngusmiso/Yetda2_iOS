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
    /// '아니오' 라고 대답한 질문의 태그들 목록
    static var tags: [String] {
        StoredData.shared._tags.map { $0 }
    }
    
    /// '아니오' 라고 대답한 질문의 태그 저장
    static func storeTag(_ tag: String) {
        StoredData.shared._tags.insert(tag)
    }
    static func removeTags(_ tags: [String]) {
        tags.forEach {
            StoredData.shared._tags.remove($0)
        }
    }
    /// 질문 중단 또는 종료 > 전체 태그 삭제
    static func removeAllTags() {
        StoredData.shared._tags.removeAll()
    }
    
    /// MainVC 실행 > 질문 시작 전 전체 리셋
    static func resetAll() {
        self.resetPrice()
        self.removeAllTags()
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
    /// 질문 번복 > 가격 기본값으로 재설정 (0 ~ 5,000만원)
    static func resetPrice() {
        StoredData.price = (0, 5_000)
    }
    /// 질문 번복 > 일반질문 재설정
    static func resetGenreralTags() {
        let genderSeasonTags: Set<String> = ["여성", "남성", "여름", "겨울"]
        let tempData = StoredData.shared._tags.filter {
            genderSeasonTags.contains($0)
        }
        StoredData.removeAllTags()
        tempData.forEach { StoredData.shared._tags.insert($0) }
    }
}
