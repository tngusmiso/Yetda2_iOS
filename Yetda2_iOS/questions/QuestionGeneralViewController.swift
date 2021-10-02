//
//  QuestionGeneralViewController.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/09/25.
//

import UIKit

class QuestionGeneralViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.navigationItem.leftBarButtonItem = YetdaNavigationBar.backButton(target: self, action: #selector(popVC))
    }
    
    @objc private func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
