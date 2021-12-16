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
    /// 응답한 특성에 해당하는 태그 문자열 목록 (String Array)
    private var tagStringArray: [String] {
        self.tags.map { $0.tag }
    }
    /// 문자열과 일치하는 RealmTag 객체 반환
    func tag(of string: String) -> RealmTag? {
        self.tags.filter("tag == %@", string).first
    }
    /// 질문에 Yes로 응답 > 질문 특성에 해당하는 태그 추가
    func addTag(_ tagList: List<RealmTag>) throws {
        do {
            try self.realm.write {
                self.realm.add(tagList)
            }
        } catch (let error) {
            print("[Failed] Tag \(tagList.map(\.tag)) 추가에 실패하였습니다. : \(error)")
        }
    }
    /// 질문 종료 > 응답 특성이 저장된 Tag 목록 전부 삭제
    func deleteAllTags() throws {
        do {
            try self.realm.write {
                self.realm.delete(self.tags)
            }
        } catch (let error) {
            print("[Failed] 모든 Tag 삭제에 실패하였습니다. : \(error)")
        }
    }
    /// 질문 번복 > 계절 관련 태그 삭제 후 재설정
    func resetSeasonTagAndReverse(_ newTagString: String?) {
        let seasonTags = self.tags.filter("tag == %@ OR tag == %@", "여름", "겨울")
        do {
            try self.realm.write {
                self.realm.delete(seasonTags)
                
                guard let tagString = newTagString?.reversedSeason else { return }
                let newTag = RealmTag()
                newTag.tag = tagString
                self.realm.add(newTag)
            }
        } catch (let error) {
            print("[Failed] 계절 Tag 갱신에 실패하였습니다. : \(error)")
        }
    }
    /// 질문 번복 > 성별 관련 태그 삭제 후 재설정
    func resetGenderTagsAndReverse(_ newTagString: String?) {
        let genderTags = self.tags.filter("tag == %@ OR tag == %@", "여성", "남성")
        do {
            try self.realm.write {
                self.realm.delete(genderTags)
                
                guard let tagString = newTagString?.reversedGender else { return }
                let newTag = RealmTag()
                newTag.tag = tagString
                self.realm.add(newTag)
            }
        } catch (let error) {
            print("[Failed] 성별 Tag 삭제에 실패하였습니다. : \(error)")
        }
    }
    
    // MARK: - 질문 정보
    /// 모든 질문
    private var questions: Results<RealmQuestion> {
        self.realm.objects(RealmQuestion.self)
    }
    /// 이미 응답한 질문  (조건 : isAsked == true)
    private var askedQuestions: Results<RealmQuestion> {
        self.questions.filter("isAsked == true")
    }
    /// 가능한 질문 (조건 : isAsked == false && 현재 tag 목록 에 해당하지 않는 질문들)
    var availableQuestions: Results<RealmQuestion> {
        self.questions.filter("isAsked == %@ AND NOT tag IN %@", false, tagStringArray)
    }
    /// 가능한 질문 중, 랜덤 질문 하나
    var randomAvailableQuestion: RealmQuestion {
        let questions = Array(self.availableQuestions)
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
    /// 질문 종료 > 이미 응답한 질문의 isAsked 필드를 false로 업데이트
    func updateAskedQuestions(asked status: Bool = false) throws {
        do {
            try self.realm.write {
                Array(askedQuestions).forEach { $0.isAsked = status }
            }
        } catch (let error) {
            print("[Failed] 모든 질문의 응답상태를 \(status)로 변경하는 것이 실패하였습니다.: \(error)")
        }
    }
    /// 질문에 응답 완료 >  isAsked 필드를 true로 업데이트
    func updateQuestion(asked status: Bool = true, questionId: Int) throws {
        guard let question = self.questions.filter("id == \(questionId)").first else {
            print("[Not Exist] id가 \(questionId)인 질문이 존재하지 않습니다.")
            return
        }
        do {
            try self.realm.write {
                question.isAsked = status
            }
        } catch (let error) {
            print("[Failed] 질문(id:\(questionId))의 응답상태를 \(status)로 변경하는 것이 실패하였습니다. : \(error)")
        }
    }
    
    // MARK: - 선물 정보
    private var gifts: Results<RealmGift> {
        self.realm.objects(RealmGift.self)
    }
    /// 질문 하나 응답 완료 > 현 시점에서 추천 가능한 전체 선물 목록
    var recommendedGifts: Results<RealmGift> {
        let price = StoredData.shared.price
        return self.gifts.filter("NOT ANY tagList IN %@ AND price BETWEEN {%@, %@}", tags, price.0, price.1)
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
