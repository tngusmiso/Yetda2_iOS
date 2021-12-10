//
//  RealmManager.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/12/11.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared: RealmManager = RealmManager()
    private let realm: Realm
    
    private init() {
        self.realm = try! Realm()
    }
    
    private var updates: Results<RealmUpdate> {
        realm.objects(RealmUpdate.self)
    }
    
    private var gifts: Results<RealmGift> {
        realm.objects(RealmGift.self)
    }
    
    private var questions: Results<RealmQuestion> {
        realm.objects(RealmQuestion.self)
    }
    
    var updatedAt: Date? {
        return self.updates.first?.updatedAt
    }
    
    func resetUpdatedAt(_ date: Date) throws {
        let update: RealmUpdate = RealmUpdate()
        update.updatedAt = date
        
        do {
            try realm.write {
                realm.delete(self.updates)
                realm.add(update)
            }
        } catch (let error) {
            print("[Failed] Reset Realm UpdateObject : \(error)")
        }
    }
    
    func resetGifts(_ newGifts: [RealmGift]) throws {
        do {
            try realm.write {
                realm.delete(self.gifts)
                realm.add(newGifts)
            }
        } catch (let error) {
            print("[Failed] Reset Realm Gifts : \(error)")
        }
    }
    
    func resetQuestions(_ newQuestions: [RealmQuestion]) throws {
        do {
            try realm.write {
                realm.delete(self.questions)
                realm.add(newQuestions)
            }
        } catch (let error) {
            print("[Failed] Reset Realm Questions : \(error)")
        }
    }
}
