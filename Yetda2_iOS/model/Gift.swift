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
    let tags = List<String>()
}
