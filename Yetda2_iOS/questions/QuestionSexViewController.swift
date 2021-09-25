//
//  QuestionSexViewController.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/09/25.
//

import UIKit

class QuestionSexViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        guard let backButtonImage = UIImage(named: "backButton") else {
            return
        }
        let backButtonItem = UIBarButtonItem(image: backButtonImage, style: .done, target: self, action: #selector(dismissVC))
        backButtonItem.tintColor = .veryLightPink
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc private func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
