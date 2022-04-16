//
//  QuestionGeneralViewController.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/09/25.
//

import UIKit

class QuestionGeneralViewController: UIViewController {
    private var question: RealmQuestion?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentCardView: QuestionCardView!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var unknownButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        self.navigationItem.leftBarButtonItem = YetdaNavigationBar.backButton(target: self, action: #selector(popVC))
        
        self.titleLabel.text = Strings.questionTitle
        self.titleLabel.textColor = .brownishGrey
        
        self.unknownButton.setTitle(Strings.unknown, for: .normal)
        self.unknownButton.setTitleColor(.veryLightPinkFour, for: .normal)
        
        self.currentCardView.showNextCardIfAvailable { [weak self] success in
            if success {
                self?.setButtonsEnabled(true)
            } else {
                self?.goToRecommendViewController()
            }
        }
    }
    
    private func setButtonsEnabled(_ enabled: Bool) {
        self.rejectButton.isEnabled = enabled
        self.confirmButton.isEnabled = enabled
        self.unknownButton.isEnabled = enabled
    }
    
    // MARK: - Actions
    @IBAction func touchRejectButton(_ sender: Any) {
        self.setButtonsEnabled(false)
        self.currentCardView.question.map {
            self.reply(for: $0.id, tag: $0.tag, positiveAnswer: false)
        }
        
        self.currentCardView.moveLeft { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.needsMoreQuestion() {
                strongSelf.currentCardView.showNextCardIfAvailable(completion: strongSelf.didLoadNextQuestion)
            } else {
                strongSelf.goToRecommendViewController()
            }
        }
    }
    @IBAction func touchConfirmButton(_ sender: Any) {
        self.setButtonsEnabled(false)
        self.currentCardView.question.map {
            self.reply(for: $0.id, tag: $0.tag, positiveAnswer: true)
        }
        
        self.currentCardView.moveRight { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.needsMoreQuestion() {
                strongSelf.currentCardView.showNextCardIfAvailable(completion: strongSelf.didLoadNextQuestion)
            } else {
                strongSelf.goToRecommendViewController()
            }
        }
    }
    @IBAction func touchUnknownButton(_ sender: Any) {
        self.setButtonsEnabled(false)
        self.currentCardView.question.map {
            self.skip(for: $0.id)
        }
        
        self.currentCardView.moveUp { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.needsMoreQuestion() {
                strongSelf.currentCardView.showNextCardIfAvailable(completion: strongSelf.didLoadNextQuestion)
            } else {
                strongSelf.goToRecommendViewController()
            }
        }
    }
    
    private func didLoadNextQuestion(_ success: Bool) {
        if success {
            self.setButtonsEnabled(true)
        } else {
            self.goToRecommendViewController()
        }
    }
    
    // MARK: - Transform
    @objc private func popVC() {
        self.resetAskedQuestion()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func goToRecommendViewController() {
        self.resetAskedQuestion()
        
        let questionStoryboard = UIStoryboard(name: "Recommend", bundle: nil)
        let recommendVC = questionStoryboard.instantiateViewController(identifier: "RecommendViewController")
        self.navigationController?.pushViewController(recommendVC, animated: true)
    }
    
    // MARK: - Features
    private func resetAskedQuestion() {
        try? RealmManager.shared.resetAskedQuestions()
        StoredData.resetGenreralTags()
    }
    
    private func needsMoreQuestion() -> Bool {
        let drawnGiftCount = RealmManager.shared.recommendedGifts.count
        let answeredQuestionCount = RealmManager.shared.answeredQuestions.count
        
        if drawnGiftCount <= 10 { // 선물이 10개 이하더라도
            if answeredQuestionCount < 3 { // 질문에 3번 미만 응답했다면 -> 질문
                return true
            }
        } else if answeredQuestionCount < 6 { // 질문에 6번 미만 응답했다면 -> 질문
            return true
        }
        return false
    }
    
    private func skip(for id: Int) {
        // 스킵했지만 질문이 다시 나오지 않아야 함.
        try? RealmManager.shared.updateQuestion(id, asked: true, answered: false)
    }
    
    private func reply(for id: Int, tag: String, positiveAnswer: Bool) {
        try? RealmManager.shared.updateQuestion(id, asked: true, answered: true)
        if positiveAnswer == false { StoredData.storeTag(tag) }
    }
}
