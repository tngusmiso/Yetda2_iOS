//
//  RealmTag.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/12/11.
//

import Foundation
import RealmSwift

/// [Realm객체] 지금까지 답한 질문에 해당하는 태그 목록
/// - var tag: String      - 태그
class RealmTag: Object {
    @objc dynamic var tag: String = ""
    
    convenience init(tag: String) {
        self.init()
        self.tag = tag
    }
}
