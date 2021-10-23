//
//  QuestionViewController.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/10/23.
//

import Foundation


protocol QuestionViewController {
    func quitQuestionVC()
    func skipVC()
    func storeData()
    func storeDataAndNextVC()
    func checkNextButtonEnable() -> Bool
}
