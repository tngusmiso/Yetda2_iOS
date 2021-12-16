//
//  QuestionGeneralViewController.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/09/25.
//

import UIKit

class QuestionGeneralViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentCardView: QuestionCardView!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var unknownButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(RealmManager.shared.recommendedGifts)
    }
    
    @IBAction func touchRejectButton(_ sender: Any) {
        currentCardView.moveLeft()
    }
    @IBAction func touchConfirmButton(_ sender: Any) {
        currentCardView.moveRight()
    }
    @IBAction func touchUnknownButton(_ sender: Any) {
        currentCardView.moveUp()
    }
    
    private func setupUI() {
        self.navigationItem.leftBarButtonItem = YetdaNavigationBar.backButton(target: self, action: #selector(popVC))
        
        self.titleLabel.text = Strings.questionTitle
        self.titleLabel.textColor = .brownishGrey

        // set image for selected state
        
        self.unknownButton.setTitle(Strings.unknown, for: .normal)
        self.unknownButton.setTitleColor(.veryLightPinkFour, for: .normal)
    }
    
    @objc private func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func reply(for tag: String, is boolean: Bool) {
        
    }
}
