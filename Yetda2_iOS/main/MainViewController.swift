//
//  MainViewController.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/09/16.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        try? RealmManager.shared.deleteAllTags()
    }
    
    @IBAction func clickStartButton(_ sender: Any) {
        goToQuestionViewController()
    }
    
    private func setupUI() {
        titleLabel.text = Strings.mainTitle
    }
    
    private func goToQuestionViewController() {
        let questionStoryboard = UIStoryboard(name: "Question", bundle: nil)
        let rootVC = questionStoryboard.instantiateViewController(identifier: "QuestionSexViewController")
        
        let navigation = UINavigationController(rootViewController: rootVC)
        navigation.modalPresentationStyle = .fullScreen
        navigation.navigationBar.standardAppearance = YetdaNavigationBar.appearance
        
        self.present(navigation, animated: true, completion: nil)
    }
}

