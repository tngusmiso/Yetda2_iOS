//
//  Gift.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/11/30.
//

import Foundation
import RealmSwift

/// [Realm객체] Firestore에서 받아온 선물 정보
/// - var id: Int               - 고유 ID
/// - var price: Int          - 가격
/// - var name: String    - 선물 이름
/// - var image: String   - 일러스트 Image URL
/// - let tags: [GiftTag] - 태그 목록
class Gift: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var price: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic let tags: [GiftTag] = []
}

class GiftTag: Object {
    @objc dynamic var tag: String = ""
}
