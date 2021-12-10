//
//  Update.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/11/30.
//

import Foundation
import RealmSwift

/// [Realm객체] 마지막으로 받아온 데이터의 갱신 정보
/// - 앱 실행 시 디바이스와 Firestore의 updateAt 정보를 비교하여,
/// - Firestore에 최신 데이터가 있는 경우, 전체 선물 목록과 질문 목록을 업데이트 한다.
class RealmUpdate: Object {
    @objc dynamic var updatedAt: Date = Date(timeIntervalSince1970: 0)
}
