//
//  Question.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/11/30.
//

import Foundation
import RealmSwift

/// [Realm객체] 질문 정보
/// - var id: Int                  - 고유 ID
/// - var question: String  - 질문 내용
/// - var tag: String           - 해당 질문에 대한 태그
/// - var isAsked: Bool      - 물어본적이 있는가?
class RealmQuestion: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var question: String = ""
    @objc dynamic var tag: String = ""
    @objc dynamic var isAsked: Bool = false
}
