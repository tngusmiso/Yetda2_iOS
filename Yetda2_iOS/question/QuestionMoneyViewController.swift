//
//  QuestionMoneyViewController.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/09/25.
//

import UIKit

class QuestionMoneyViewController: UIViewController {
    let nextVC = UIStoryboard(name: "Question", bundle: nil)
        .instantiateViewController(identifier: "QuestionGeneralViewController")
        as! QuestionGeneralViewController
    
    var minPrice: Int { Int(minPriceTextField.text ?? "") ?? 0 }
    var maxPrice: Int { Int(maxPriceTextField.text ?? "") ?? 5_000 }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var minPriceTextField: UITextField!
    @IBOutlet weak var maxPriceTextField: UITextField!
    @IBOutlet weak var nextButton: HorizontalRoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.navigationItem.leftBarButtonItem = YetdaNavigationBar.backButton(target: self, action: #selector(quitQuestionVC))
        self.navigationItem.rightBarButtonItem = YetdaNavigationBar.skipButton(target: self, action: #selector(skipVC))
        
        self.titleLabel.text = Strings.moneyTitle
        self.titleLabel.textColor = .brownishGrey
        
        self.minPriceTextField.delegate = self
        self.minPriceTextField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        self.maxPriceTextField.delegate = self
        self.maxPriceTextField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        
        self.nextButton.text = Strings.next
        self.nextButton.isEnabled = checkNextButtonEnable()
        self.nextButton.addTarget(self, action: #selector(storeDataAndNextVC), for: .touchUpInside)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func textFieldEditingDidEnd(_ sender: UITextField) {
        
    }
}

extension QuestionMoneyViewController: QuestionViewController {
    @objc func quitQuestionVC() {
        // 팝업
        StoredData.resetPrice()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func skipVC() {
        StoredData.resetPrice()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func storeData() {
        StoredData.price = (minPrice, maxPrice)
    }
    
    @objc func storeDataAndNextVC() {
        self.storeData()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func checkNextButtonEnable() -> Bool {
        minPrice <= maxPrice
    }
}

extension QuestionMoneyViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.nextButton.isEnabled = checkNextButtonEnable()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.invalidateIntrinsicContentSize()
        
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return false
        }
        
        let newText = text.replacingCharacters(in: textRange, with: string)
        guard let intValue = Int(newText) else {
            // backspace
            if string.isEmpty {
                textField.text = newText
            }
            self.nextButton.isEnabled = self.checkNextButtonEnable()
            return false
        }
        
        if intValue <= 0 {
            textField.text = "0"
        } else if intValue > 5000 {
            textField.text = "5000"
        } else {
            textField.text = String(format: "%d", intValue)
        }
        
        self.nextButton.isEnabled = self.checkNextButtonEnable()
        return false
    }
}
