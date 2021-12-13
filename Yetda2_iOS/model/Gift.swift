//
//  Gift.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/12/02.
//

import Foundation
import RealmSwift

/// [Realm객체] 선물 정보
/// - var id: Int                  - 고유 ID
/// - var name: String      - 선물 이름
/// - var price: Int             - 가격
/// - var tags: [String]    - 선물 특성 태그
/// - var image: String      - 이미지 URL
class RealmGift: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var price: Int = 1
    @objc dynamic var image: String = ""
    let tagList = List<RealmTag>()
    private var tags: [String] {
        get {
            tagList.map { $0.tag }
        }
        set {
            tagList.removeAll()
            newValue.compactMap {
                RealmManager.shared.tag(of: $0)
            }.forEach {
                tagList.append($0)
            }
        }
    }
    
    init(firestoreGift gift: FirestoreManager.Gift) {
        super.init()
        self.id = gift.id
        self.name = gift.name
        self.price = gift.price
        self.image = gift.image
        self.tags = gift.tags
    }
    
    required override init() {
        super.init()
    }
}
