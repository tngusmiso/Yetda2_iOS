//
//  NumericTextField.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/10/23.
//

import UIKit

class NumericTextField: UITextField {
    // 범위
    private var length: Int = 2     // 입력필드 길이
    private var max: Int = 1   // 최대 숫자 범위
    private var min: Int = 1   // 최소 숫자 범위
    var maxValue: Int { max }
    var minValue: Int { min }
    
    var value: Int = 0 {    // 담고 있는 값
        didSet { self.text = formattedValue }
    }
    private var formattedValue: String { // 실제 보여질 text
        String(format: "%0\(length)d", value)
    }
    
    // MARK: - Initializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.keyboardType = .numberPad
    }
    
    func setup(length: Int = 2, min: Int = 1, max: Int = 1) {
        self.length = length
        self.min = min
        self.max = max
    }
    
    func input(value inputValue: String) {
        // backspace
        if inputValue.isEmpty {
            self.value = value / Int(10)
        }
        // 숫자 외에는 입력 불가
        guard let newValue = Int("\(self.value)\(inputValue)") else {
            return
        }
        // 범위 판별
        if newValue > maxValue {
            self.value = maxValue
        } else {
            self.value = newValue
        }
    }
}
