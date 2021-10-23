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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monthTextField: NumericTextField!
    @IBOutlet weak var dateTextField: NumericTextField!
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
        self.monthTextField.setup(length: 2, min: 1, max: 12)
        self.dateTextField.delegate = self
        self.dateTextField.setup(length: 2, min: 1, max: 31)
        
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
    
    func checkNextButtonEnable() -> Bool {
        self.month.isEmpty == false && self.date.isEmpty == false
    }
}

extension QuestionBirthdayViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // keypad 닫을 때 최소값 판별
        if let numericTextField = textField as? NumericTextField {
            if numericTextField.value < numericTextField.minValue {
                numericTextField.value = numericTextField.minValue
            }
        }
        // 다음버튼 활성화
        self.nextButton.isEnabled = checkNextButtonEnable()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let numericTextField = textField as? NumericTextField else {
            return true
        }
        if numericTextField == self.dateTextField {
            switch self.monthTextField.value {
            case 2:
                numericTextField.setup(max: 29)
            case 4,6,9,11:
                numericTextField.setup(max: 30)
            case 1,3,5,7,8,10,12:
                numericTextField.setup(max: 31)
            default:
                break
            }
        }
        numericTextField.input(value: string)
        return false
    }
}
