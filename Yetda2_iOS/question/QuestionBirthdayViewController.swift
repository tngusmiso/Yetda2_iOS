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
    
    private var month: String { monthTextField.text ?? "" }
    private var date: String { dateTextField.text ?? "" }
    private var season: String? {
        guard let month = Int(month) else {
            return nil
        }
        switch month {
        case 1,2,11,12:
            return "겨울"
        case 6,7,8,9:
            return "여름"
        default:
            return nil
        }
    }

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
        self.titleLabel.textColor = .brownishGrey
        
        self.monthTextField.delegate = self
        self.dateTextField.delegate = self
        
        self.nextButton.text = Strings.next
        self.nextButton.isEnabled = checkNextButtonEnable()
        self.nextButton.addTarget(self, action: #selector(storeDataAndNextVC), for: .touchUpInside)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension QuestionBirthdayViewController: QuestionViewController {
    @objc func quitQuestionVC() {
        // 팝업
        StoredData.resetSeasonTagAndReverse(nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func skipVC() {
        StoredData.resetSeasonTagAndReverse(nil)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func storeData() {
        StoredData.resetSeasonTagAndReverse(self.season)
    }
    
    @objc func storeDataAndNextVC() {
        // 버튼 활성화 상태 한번 더 체크
        guard self.checkNextButtonEnable() else {
            return
        }
        self.storeData()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func checkNextButtonEnable() -> Bool {
        guard let month = Int(self.month), let date = Int(self.date) else {
            return false
        }
        if month < 1 || date < 1 {
            return false
        }
        if month > 12 || date > maxDate(of: month) ?? 0 {
            return false
        }
        return true
    }
}

extension QuestionBirthdayViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let intValue = Int(text) else {
            self.nextButton.isEnabled = false
            return
        }
        
        textField.text = String(format: "%02d", intValue)
        
        // 다음버튼 활성화
        self.nextButton.isEnabled = checkNextButtonEnable()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 숫자 외에는 입력 불가
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return false
        }
        
        // 숫자 외에는 입력 불가
        guard let newValue = Int(text.replacingCharacters(in: textRange, with: string)) else {
            // backspace 예외
            if string.isEmpty {
                textField.text = text.replacingCharacters(in: textRange, with: string)
            }
            self.nextButton.isEnabled = checkNextButtonEnable()
            return false
        }
        
        if newValue > 99 { return false }
        
        textField.text = String(format: "%d", newValue)
        self.nextButton.isEnabled = checkNextButtonEnable()
        
        return false
    }
    
    private func maxDate(of month: Int?) -> Int? {
        switch month {
        case 2:
            return 29
        case 4,6,9,11:
            return 30
        case 1,3,5,7,8,10,12:
            return 31
        default:
            return nil
        }
    }
    
    private func setDateTextFieldMaxIfNeed(from newDate: Int) {
        var newDate = newDate
        
        // monthTextField의 입력이 잘못되었다면 (없다면)
        guard let month = Int(self.month),
              let maxDate = self.maxDate(of: month) else {
            if newDate > 31 { newDate = 31 }
            self.dateTextField.text = String(format: "%02d", newDate)
            return
        }
        
        if newDate > maxDate { newDate = maxDate }
        self.dateTextField.text = String(format: "%02d", newDate)
    }
}
