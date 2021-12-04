//
//  Gift.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/12/02.
//

import Foundation
import RealmSwift

class Gift: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var tags: String = ""
    @objc dynamic var image: String = ""
}
