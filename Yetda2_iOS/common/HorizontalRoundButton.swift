//
//  HorizontalRoundButton.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/10/02.
//

import UIKit

class HorizontalRoundButton: UIButton {
    // MARK: - Properties
    override var isEnabled: Bool {
        didSet { self.setNeedsLayout() }
    }
    
    var text: String = "" {
        didSet { self.setNeedsLayout() }
    }
    
    var textSize: CGFloat = 20 {
        didSet { self.setNeedsLayout() }
    }
    
    var height: CGFloat = 52 {
        didSet { self.setNeedsLayout() }
    }
    
    // MARK: - Initializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        if isEnabled { setEnable() }
        else { setDisable() }
        
        setText()
        self.frame.size.height = self.height
        self.layer.cornerRadius = self.frame.size.height / CGFloat(2.0)
        
        super.layoutSubviews()
    }
    
    // MARK: - Methods
    private func setEnable() {
        self.backgroundColor = .pastelRed
        self.setTitleColor(.white253, for: .normal)
    }
    
    private func setDisable() {
        self.backgroundColor = .veryLightPinkTwo
        self.setTitleColor(.white253, for: .normal)
    }
    
    private func setText() {
        self.setTitle(self.text, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: self.textSize)
    }
}
