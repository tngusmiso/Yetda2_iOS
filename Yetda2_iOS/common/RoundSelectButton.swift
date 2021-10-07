//
//  RoundSelectButton.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/10/07.
//

import UIKit

class RoundSelectButton: UIButton {
    // MARK: - Properties
    override var isSelected: Bool {
        didSet { self.setNeedsLayout() }
    }
    
    var text: String = "" {
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
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        self.backgroundColor = .white253
        self.tintColor = .clear
        self.isHighlighted = false
        
        if isSelected { setSelected() }
        else { setUnselected() }
        
        setText()
        self.frame.size = CGSize(width: self.size, height: self.size)
        self.layer.cornerRadius = self.size / CGFloat(2.0)
        
        super.layoutSubviews()
    }
    
    // MARK: - Methods
    private func setSelected() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.pastelRed.cgColor
        self.setTitleColor(.pastelRed, for: .selected)
    }
    private func setUnselected() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.paleLilac.cgColor
        self.setTitleColor(.blueGrey, for: .normal)
    }
    
    private func setText() {
        self.setTitle(self.text, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: self.textSize)
    }
}
