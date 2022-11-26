//
//  UIImageView+Extension.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2022/11/27.
//

import UIKit

extension UIImageView {
    
    func setGifImage(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else {
            print("Gif does not exist at that path")
            self.image = nil
            return
        }
        
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else {
            self.image = nil
            return
        }
        
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        self.animationImages = images
    }
}
