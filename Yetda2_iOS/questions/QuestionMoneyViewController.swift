//
//  QuestionMoneyViewController.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/09/25.
//

import UIKit

class QuestionMoneyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.navigationItem.leftBarButtonItem = YetdaNavigationBar.backButton(target: self, action: #selector(popVC))
        self.navigationItem.rightBarButtonItem = YetdaNavigationBar.skipButton(target: self, action: #selector(skipVC))
    }
    
    @objc private func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func skipVC() {
        // skip
    }
}
