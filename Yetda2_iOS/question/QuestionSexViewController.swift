//
//  QuestionSexViewController.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/09/25.
//

import UIKit

class QuestionSexViewController: UIViewController {
    let nextVC = UIStoryboard(name: "Question", bundle: nil)
        .instantiateViewController(identifier: "QuestionBirthdayViewController")
        as! QuestionBirthdayViewController
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var femaleButton: RoundSelectButton!
    @IBOutlet weak var maleButton: RoundSelectButton!
    @IBOutlet weak var nextButton: HorizontalRoundButton!
    
    private var roundButtonGroup: RoundSelectGroup?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        roundButtonGroup = RoundSelectGroup(femaleButton, maleButton)
    }
    
    private func setup() {
        self.navigationItem.leftBarButtonItem = YetdaNavigationBar.backButton(target: self, action: #selector(quitQuestionVC))
        self.navigationItem.rightBarButtonItem = YetdaNavigationBar.skipButton(target: self, action: #selector(skipVC))
        
        self.titleLabel.text = Strings.sexTitle
        self.titleLabel.textColor = .brownishGrey
        
        self.femaleButton.text = Strings.female
        self.maleButton.text = Strings.male
        
        self.nextButton.text = Strings.next
        self.nextButton.isEnabled = checkNextButtonEnable()
        self.nextButton.addTarget(self, action: #selector(storeDataAndNextVC), for: .touchUpInside)
    }
}

// MARK: - QuestionVC 공통 함수
extension QuestionSexViewController: QuestionViewController {
    @objc func quitQuestionVC() {
        // 팝업
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func skipVC() {
        RealmManager.shared.resetGenderTagsAndReverse(nil)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func storeData() {
        let gender = self.roundButtonGroup?.selectedButton == self.femaleButton ? "여성" : "남성"
        RealmManager.shared.resetGenderTagsAndReverse(gender)
    }
    
    @objc func storeDataAndNextVC() {
        self.storeData()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func checkNextButtonEnable() -> Bool {
        true
    }
}
