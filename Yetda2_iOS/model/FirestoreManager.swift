//
//  FirestoreManager.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/12/10.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirestoreManager {
    static let shared =  FirestoreManager()
    private let db: Firestore
    
    private init() {
        FirebaseApp.configure()
        self.db = Firestore.firestore()
    }
    
    func getRecentUpdatedDate(completion: @escaping (Date) -> Void) {
        let docRef = db.collection("updates").document("recent_updates")
        docRef.getDocument { (document, error) in
            if let error = error {
                print("[Error] getting UpdateModel from Firestore: \(error)")
                return
            }
            
            let result = Result {
                try document?.data(as: Update.self)
            }
            
            switch result {
            case .success(let update):
                guard let updatedAt = update?.updatedAt else {
                    print("[Not Exist] UpdateModel in Firestore")
                    return
                }
                completion(updatedAt.dateValue())
            case .failure(let error):
                print("[Error] Decoding UpdateModel: \(error)")
            }
        }
    }
    
    func getGifts(completion: @escaping ([Gift]) -> Void) {
        db.collection("presents").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("[Error] getting Gifts from Firestore: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("[Not Exist] Gifts in Firestore")
                return
            }
            
            let gifts: [Gift] = documents.compactMap { try? $0.data(as: Gift.self) }
            if gifts.isEmpty {
                print("[Error] Decoding Gifts")
                return
            }
            completion(gifts)
        }
    }
    
    func getQuestions(completion: @escaping ([Question]) -> Void) {
        db.collection("question").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("[Error] getting Questions from Firestore: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("[Not Exist] Questions in Firestore")
                return
            }
            
            let questions: [Question] = documents.compactMap { try? $0.data(as: Question.self) }
            if questions.isEmpty {
                print("[Error] Decoding Questions")
                return
            }
            completion(questions)
        }
    }
}

protocol FirestoreModel: Decodable { }
extension FirestoreManager {
    /// [Realm객체] Firestore 데이터 갱신 정보
    /// - 앱 실행 시 디바이스와 Firestore의 updateAt 정보를 비교하여,
    /// - Firestore에 최신 데이터가 있는 경우, 전체 선물 목록과 질문 목록을 업데이트 한다.
    struct Update: FirestoreModel {
        var updatedAt: Timestamp
        enum CodingKeys : String, CodingKey {
            case updatedAt = "updated_at"
        }
    }
    
    /// [Firestore객체] 선물 정보
    /// - var id: Int                  - 고유 ID
    /// - var name: String      - 선물 이름
    /// - var price: Int             - 가격
    /// - var tags: [String]    - 선물 특성 태그
    /// - var image: String      - 이미지 URL
    struct Gift: FirestoreModel {
        var id: Int
        var name: String
        var price: Int
        var image: String
        var tags: [String]
    }

    /// [Firestore객체] 질문 정보
    /// - var id: Int                  - 고유 ID
    /// - var question: String  - 질문 내용
    /// - var tag: String           - 해당 질문에 대한 태그
    /// - var isAsked: Bool      - 물어본적이 있는가?
    struct Question: FirestoreModel {
        var id: Int
        var question: String
        var tag: String
    }
}
