//
//  RecommendViewController.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/12/02.
//

import Kingfisher
import RealmSwift
import UIKit

class RecommendViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var anotherGiftButton: UIButton!
    @IBOutlet weak var homeButton: HorizontalRoundButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var gifts: [RealmGift] = []
    private var giftIndex: Int = 0
    
    private var giftName: String = "" {
        didSet { self.giftNameLabel.text = giftName }
    }
    private let giftImagePlaceholder = UIImage(named: "giftPlaceholder")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        self.titleLabel.text = Strings.recommendTitle
        
        self.gifts = RealmManager.shared.recommendedGifts.shuffled()
        self.showRecommendResult()
        
        self.homeButton.text = Strings.home
    }

    @IBAction func touchAnotherGiftButton(_ sender: Any) {
        self.showRecommendResult()
    }
    
    @IBAction func goToHomeVC(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    private func showRecommendResult() {
        guard gifts.isEmpty == false else {
            self.setEmptyRecommendStatus()
            return
        }
        
        if self.giftIndex >= gifts.count {
            self.giftIndex = 0
            self.gifts.shuffle()
        }
        
        let gift = gifts[self.giftIndex]
        self.giftName = gift.name
        self.setImage(stringURL: gift.image)
        self.giftIndex += 1
    }
    
    private func setEmptyRecommendStatus() {
        self.giftName = ""
        self.giftImageView.image = self.giftImagePlaceholder
        self.descriptionLabel.text = "추천할 수 있는 선물이 없습니다."
        self.anotherGiftButton.isHidden = true
    }
    
    private func setImage(stringURL: String) {
        let imageURL = URL(string: stringURL)
        self.giftImageView.kf.setImage(
            with: imageURL,
            placeholder: self.giftImagePlaceholder
        )
    }
}
