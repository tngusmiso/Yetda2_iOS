//
//  RoundSelectGroup.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/10/07.
//

import UIKit

class RoundSelectGroup {
    var selectedButton: RoundSelectButton? {
        willSet { selectedButton?.isSelected = false }
        didSet { selectedButton?.isSelected = true }
    }
    
    init(_ buttons: RoundSelectButton...) {
        buttons.forEach { $0.group = self }
        self.selectedButton = buttons.first
        buttons.first?.isSelected = true
    }
    
    func touched(_ button: RoundSelectButton) {
        selectedButton = button
    }
}
