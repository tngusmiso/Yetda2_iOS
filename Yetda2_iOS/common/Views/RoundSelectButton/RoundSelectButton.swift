//
//  RoundSelectButton.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/10/07.
//

import UIKit

class RoundSelectButton: UIButton {
    // MARK: - Properties
    weak var group: RoundSelectGroup?

    var text: String = Strings.defaultButton {
        didSet { self.setNeedsLayout() }
    }
    
    var textSize: CGFloat = 26 {
        didSet { self.setNeedsLayout() }
    }
    
    var size: CGFloat {
        get { self.frame.size.width }
        set { self.frame.size = CGSize(width: newValue, height: newValue) }
    }
    
    // MARK: - Initializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(touched), for: .touchUpInside)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        if isSelected {
            self.setSelectedUI()
        } else {
            self.setUnselectedUI()
        }
        
        // text
        setText()
        
        // color
        self.backgroundColor = .white253
        self.tintColor = .clear
        self.isHighlighted = false
        
        // outlook
        self.frame.size = CGSize(width: self.size, height: self.size)
        self.layer.cornerRadius = self.size / CGFloat(2.0)
        
        super.layoutSubviews()
    }
    
    // MARK: - Methods
    
    /* 터치했을 때 선택되는 버튼을 결정하는 로직
     -> group.touch(_:) 함수 실행
     -> group의 selectedButton 결정
     -> selectedButton이 set 되면서, 변경전 버튼은 isSelected = false, 변경후 버튼은 isSelected = true 실행
     -> isSelected에 따라 layout Update
     */
    
    @IBAction private func touched() {
        self.group?.touched(self)
    }
    
    private func setSelectedUI() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.pastelRed.cgColor
    }
    
    private func setUnselectedUI() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.paleLilac.cgColor
    }
    
    private func setText() {
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: self.textSize)
        self.setTitle(self.text, for: .normal)
        self.setTitleColor(.blueGrey, for: .normal)
        self.setTitleColor(.pastelRed, for: .selected)
    }
}
