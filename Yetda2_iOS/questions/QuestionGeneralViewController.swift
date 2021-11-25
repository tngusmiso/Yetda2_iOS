//
//  QuestionGeneralViewController.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/09/25.
//

import UIKit

class QuestionGeneralViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backCardView: UIView!
    @IBOutlet weak var currentCardView: UIView!
    
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var unknownButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func touchRejectButton(_ sender: Any) {
    }
    @IBAction func touchConfirmButton(_ sender: Any) {
    }
    @IBAction func touchUnknownButton(_ sender: Any) {
    }
    
    private func setupUI() {
        self.navigationItem.leftBarButtonItem = YetdaNavigationBar.backButton(target: self, action: #selector(popVC))
        
        self.titleLabel.text = Strings.questionTitle
        self.titleLabel.textColor = .brownishGrey
        
        self.backCardView.layer.cornerRadius = 14
        self.backCardView.layer.shadowRadius = 20
        self.backCardView.layer.shadowOpacity = 0.1
        self.backCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        self.currentCardView.layer.cornerRadius = 14
        self.currentCardView.layer.shadowRadius = 20
        self.currentCardView.layer.shadowOpacity = 0.1
        self.currentCardView.layer.shadowOffset = CGSize(width: 0, height: 4)

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
