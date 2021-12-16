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
    @IBOutlet weak var presentImageView: UIImageView!
    @IBOutlet weak var presentNameLabel: UILabel!
    @IBOutlet weak var presnetResetButton: UIButton!
    @IBOutlet weak var moveToHomeButton: HorizontalRoundButton!
    
    var giftList = [RealmGift]()
    var index = 0
    var giftName = "" {
        didSet { self.view.layoutIfNeeded() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get gift list from realm
        //progress on
        setup()
    }
    
    private func setup(){
//        progress on
        self.titleLabel.text = Strings.resultTitle
        self.titleLabel.textColor = .brownishGrey
        self.moveToHomeButton.setTitle(Strings.home, for: .normal)
        
        // TODO: 출시를 위해 hidden 처리
        self.presnetResetButton.isEnabled = false
        self.presnetResetButton.alpha = 0
        
        setGift()
    }

    private func setGift(){
//        if(index < giftList.count){
//            self.presentImageView.kf.setImage(with: URL(string: giftList[index].image))
//            self.presentNameLabel.text = giftList[index].name
//            index+=1
//        }else{
//            index = 0
//        }
        //progress off
    }
    
    @IBAction func touchAnotherGiftButton(_ sender: Any) {
        setGift()
    }
    
    @IBAction func touchMoveToHomeButton(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
}
