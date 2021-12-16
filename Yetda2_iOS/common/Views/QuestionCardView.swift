//
//  QuestionCardView.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/11/29.
//

import UIKit

class QuestionCardView: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 34)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        // cardview appearances
        self.layer.cornerRadius = 14
        self.layer.shadowRadius = 20
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        
        // label constraints
        self.addSubview(label)
        NSLayoutConstraint.activate([
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CGFloat(20)),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: CGFloat(-20)),
            self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        // setup with state
        self.setNormalView()
    }

    private func setNormalView() {
        self.backgroundColor = .white
        self.label.textColor = .black
    }
    
    private func setRejectedView() {
        self.backgroundColor = .blueGrey
        self.label.textColor = .white
    }
    
    private func setConfirmedView() {
        self.backgroundColor = .pastelRed
        self.label.textColor = .white
    }
    
    
    // MARK: - 애니메이션
    /// CardView 좌우 슬라이드 애니메이션  이동거리
    private var movingDistance: CGFloat? {
        guard let superview = self.superview else {
            return nil
        }
        let leadingDistance = self.frame.minX - superview.frame.minX
        return leadingDistance + self.frame.width
    }
    
    /// REJECTED
    func moveLeft() {
        guard let movingDistance = self.movingDistance else {
            return
        }
        self.setRejectedView()
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.transform = CGAffineTransform(translationX: -movingDistance, y: 0)
        } completion: { [weak self] _ in
            self?.setNormalView()
            self?.showNextCard()
        }
    }
    
    /// CONFIRMED
    func moveRight() {
        guard let movingDistance = self.movingDistance else {
            return
        }
        
        self.setConfirmedView()
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.transform = CGAffineTransform(translationX: movingDistance, y: 0)
        } completion: { [weak self] _ in
            self?.setNormalView()
            self?.showNextCard()
        }
    }
    
    /// UNKNOWN
    func moveUp() {
        guard let movingDistance = self.movingDistance else {
            return
        }
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.transform = CGAffineTransform(translationX: 0, y: -2 * movingDistance)
        } completion: { [weak self] _ in
            self?.setNormalView()
            self?.showNextCard()
        }
    }
    
    private func showNextCard() {
        self.alpha = 0
        self.transform = CGAffineTransform.identity
        // 새로운 질문 로드
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
}


