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
    
    // MARK: - 최근 업데이트 정보
    /// 업데이트 이력
    private var updates: Results<RealmUpdate> {
        self.realm.objects(RealmUpdate.self).sorted(byKeyPath: "updatedAt", ascending: false)
    }
    /// 가장 최근 업데이트 객체 (updatedAt 내림차순 정렬, first)
    private var recentUpdate: RealmUpdate? {
        self.updates.first
    }
    /// 가장 최근 업데이트 날짜 (Date)
    var recentUpdateDate: Date? {
        return self.updates.first?.updatedAt
    }
    /// 업데이트 항목 추가
    func addUpdate(date: Date) throws {
        let update: RealmUpdate = RealmUpdate()
        update.updatedAt = date
        
        do {
            try self.realm.write {
                self.realm.add(update)
            }
        } catch (let error) {
            print("[Failed] 새로운 Update 기록 추가에 실패하였습니다. : \(error)")
        }
    }
    /// 앱 실행 > 업데이트 시도 > 실패 시, 최근 업데이트 내역을 제거하여 재다운로드 가능하도록 함.
    func deleteRecentUpdate() throws {
        guard let recentUpdateInfo = self.recentUpdate else {
            print("[Not Exist] 삭제할 Update 기록이 없습니다.")
            return
        }
        do {
            try self.realm.write {
                self.realm.delete(recentUpdateInfo)
            }
        } catch (let error) {
            print("[Failed] 최근 Update 기록 삭제에 실패하였습니다. : \(error)")
        }
    }
    
    // MARK: - 태그 정보
    /// 응답한 특성에 해당하는 Tag 목록 (Results<RealmTag>)
    var tags: Results<RealmTag> {
        self.realm.objects(RealmTag.self)
    }
    var storedTags: Results<RealmTag> {
//        let storedTagList = List<RealmTag>()
//        storedTagList.append(objectsIn: StoredData.tags.map { RealmTag(tag: $0) })
        return self.tags.filter("tag IN %@", StoredData.tags)
    }
    var storedTagStringArray: [String] {
        self.storedTags.map { $0.tag }
    }
    /// 문자열과 일치하는 RealmTag 객체 반환
    func tag(of string: String) -> RealmTag? {
        self.tags.filter("tag == %@", string).first
    }
    /// 응답한 질문 태그 저장
    func addTagOfGift(_ tag: RealmTag) throws {
        do {
            try self.realm.write {
                self.realm.add(tag)
            }
            print("\(tag.tag) 저장: \(self.storedTagStringArray)")
        } catch (let error) {
            print("[Failed] Tag \(tag.tag)) 추가에 실패하였습니다. : \(error)")
        }
    }
    
    // MARK: - 질문 정보
    /// 모든 질문
    private var questions: Results<RealmQuestion> {
        self.realm.objects(RealmQuestion.self)
    }
    /// 응답한 질문 (조건: isAnswered == true)
    var answeredQuestions: Results<RealmQuestion> {
        self.questions.filter("isAnswered == true")
    }
    /// 이미 물어본 질문  (조건 : isAsked == true)
    var askedQuestions: Results<RealmQuestion> {
        self.questions.filter("isAsked == true")
    }
    /// 가능한 질문 (조건 : isAsked == false && 현재 tag 목록 에 해당하지 않는 질문들)
    var availableQuestions: Results<RealmQuestion> {
        self.questions.filter("isAsked == %@ AND NOT tag IN %@", false, self.storedTagStringArray)
    }
    /// 가능한 질문 중, 랜덤 질문 하나
    var randomAvailableQuestion: RealmQuestion? {
        let questions = Array(self.availableQuestions)
        if questions.isEmpty { return nil }
        return questions[Int.random(in: 0..<questions.count)]
    }
    /// 앱 실행 > 새 버전이 있을 시 질문 업데이트 (새 질문들로 초기화)
    func resetQuestions(_ newQuestions: [RealmQuestion]) throws {
        do {
            try self.realm.write {
                self.realm.delete(self.questions)
                self.realm.add(newQuestions)
            }
        } catch (let error) {
            print("[Failed] 새로운 버전의 질문들로 초기화에 실패하였습니다. : \(error)")
        }
    }
    /// 질문 종료 > 이미 응답한 질문의 isAsked, isAnswered 필드를 false로 업데이트
    func resetAskedQuestions() throws {
        do {
            try self.realm.write {
                Array(askedQuestions).forEach {
                    $0.isAsked = false
                }
                Array(answeredQuestions).forEach {
                    $0.isAnswered = false
                }
            }
        } catch (let error) {
            print("[Failed] 모든 질문의 응답상태를 false로 변경하는 것이 실패하였습니다.: \(error)")
        }
    }
    /// 질문 노출 >  isAsked 필드를 true로 업데이트 /
    /// 질문 응답 >  isAnswered 필드를 true로 업데이트 /
    /// 건너뛰기 >  isAnswered 필드를 false로 업데이트
    func updateQuestion(_ questionId: Int, asked: Bool = true, answered: Bool = true) throws {
        guard let question = self.questions.filter("id == \(questionId)").first else {
            print("[Not Exist] id가 \(questionId)인 질문이 존재하지 않습니다.")
            return
        }
        do {
            try self.realm.write {
                question.isAsked = asked
                question.isAnswered = answered
            }
        } catch (let error) {
            print("[Failed] 질문(id:\(questionId))의 질문상태를 \(asked)로, 응답상태를 \(answered)로 변경하는 것이 실패하였습니다. : \(error)")
        }
    }
    
    // MARK: - 선물 정보
    private var gifts: Results<RealmGift> {
        self.realm.objects(RealmGift.self)
    }
    /// 질문 하나 응답 완료 > 현 시점에서 추천 가능한 전체 선물 목록
    var recommendedGifts: Results<RealmGift> {
        let price = StoredData.price
        return self.gifts.filter("NOT ANY tagList IN %@ AND price BETWEEN {%@, %@}", self.storedTags, price.0 * 10_000, price.1 * 10_000)
    }
    /// 앱 실행 > 새 버전이 있을 시 선물 업데이트 (새 선물들로 초기화)
    func resetGifts(_ newGifts: [RealmGift]) throws {
        do {
            try self.realm.write {
                self.realm.delete(self.gifts)
                self.realm.add(newGifts)
            }
        } catch (let error) {
            print("[Failed] 선물 목록 초기화에 실패하였습니다. : \(error)")
        }
    }
}
