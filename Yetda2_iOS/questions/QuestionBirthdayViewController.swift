//
//  QuestionBirthdayViewController.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/09/25.
//

import UIKit

class QuestionBirthdayViewController: UIViewController {
    let nextVC = UIStoryboard(name: "Question", bundle: nil)
        .instantiateViewController(identifier: "QuestionMoneyViewController")
        as! QuestionMoneyViewController
    
    private var monthInput: String = ""
    private var dateInput: String = ""

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nextButton: HorizontalRoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.navigationItem.leftBarButtonItem = YetdaNavigationBar.backButton(target: self, action: #selector(quitQuestionVC))
        self.navigationItem.rightBarButtonItem = YetdaNavigationBar.skipButton(target: self, action: #selector(skipVC))
        
        self.titleLabel.text = Strings.birthdayTitle
        
        self.monthTextField.delegate = self
        self.dateTextField.delegate = self
        
        self.nextButton.text = Strings.next
        self.nextButton.addTarget(self, action: #selector(storeDataAndNextVC), for: .touchUpInside)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension QuestionBirthdayViewController: QuestionViewController {
    @objc func quitQuestionVC() {
        // 팝업
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func skipVC() {
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func storeData() {
        // 날짜 저장
    }
    
    @objc func storeDataAndNextVC() {
        self.storeData()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension QuestionBirthdayViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // text: 원래 글자
        // string: 추가될 글자
        // Range: 추가될 문자열 범위(index, 몇칸)
        
        // 숫자 또는 backspace만 입력 가능
        if string.isNumber == false && string.isEmpty == false {
            return false
        }
        // 최대 두자리
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 2
    }
}

extension String {
    var isNumber: Bool {
        Int(self) != nil
    }
}
