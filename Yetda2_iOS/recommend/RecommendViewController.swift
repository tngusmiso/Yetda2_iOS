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
    private let animationView: UIImageView = UIImageView()
    
    private var gifts: [RealmGift] = []
    private var giftIndex: Int = 0
    
    private var giftName: String = "" {
        didSet { self.giftNameLabel.text = giftName }
    }
    private let giftImagePlaceholder = UIImage(named: "giftPlaceholder")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        self.setupUI()
        self.gifts = RealmManager.shared.recommendedGifts.shuffled()
        self.showRecommendResult()
    }

    @IBAction func touchAnotherGiftButton(_ sender: Any) {
        self.showRecommendResult()
    }
    
    @IBAction func goToHomeVC(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    private func setupUI() {
        self.titleLabel.text = Strings.recommendTitle
        self.homeButton.text = Strings.home
        
        self.view.addSubview(self.animationView)
        self.animationView.frame = self.view.frame
        self.animationView.setGifImage(name: "pung")
    }
    
    private func showRecommendResult() {
        guard gifts.isEmpty == false else {
            self.showEmptyRecommendStatus()
            return
        }
        
        if animationView.isAnimating == false {
            self.animationView.animationRepeatCount = 1
            self.animationView.startAnimating()
        }
        
        if self.giftIndex >= gifts.count {
            self.giftIndex = 0
            self.gifts.shuffle()
        }
        
        let gift = gifts[self.giftIndex]
        self.giftName = gift.name
        self.setGiftImage(url: gift.image)
        self.giftIndex += 1
    }
    
    private func showEmptyRecommendStatus() {
        self.giftName = ""
        self.giftImageView.image = self.giftImagePlaceholder
        self.descriptionLabel.text = "추천할 수 있는 선물이 없습니다."
        self.anotherGiftButton.isHidden = true
    }
    
    private func setGiftImage(url: String) {
        let imageURL = URL(string: url)
        self.giftImageView.kf.setImage(
            with: imageURL,
            placeholder: self.giftImagePlaceholder
        )
    }
}
