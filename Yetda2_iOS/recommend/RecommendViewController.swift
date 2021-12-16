//
//  RecommendViewController.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/12/02.
//

import UIKit
import Kingfisher

class RecommendViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var giftImage: UIImageView!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var anotherGiftButton: UIButton!
    @IBOutlet weak var homeButton: HorizontalRoundButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var giftName = "" {
        didSet {
            self.giftNameLabel.text = giftName
            if giftName == "" {
                self.descriptionLabel.text = "추천할 수 있는 선물이 없습니다."
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        self.titleLabel.text = Strings.recommendTitle
        
        let gifts = RealmManager.shared.recommendedGifts
        if gifts.count > 0 {
            self.giftName = gifts[Int.random(in: 0..<gifts.count)].name
        } else {
            self.giftName = ""
        }
        self.homeButton.text = Strings.home
        self.homeButton.addTarget(self, action: #selector(goToHomeVC), for: .touchUpInside)
        
        // TODO: 출시를 위해 hidden 처리
        self.anotherGiftButton.isEnabled = false
        self.anotherGiftButton.alpha = 0
    }

    @objc func goToHomeVC() {
        self.navigationController?.dismiss(animated: true)
    }
}
