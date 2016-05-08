//
//  DiscoverRestaurants.swift
//  EatLike
//
//  Created by Queen Y on 16/4/4.
//  Copyright © 2016年 Queen. All rights reserved.
//

import UIKit

class DiscoverRestaurants {
    let name: String
    let userName: String
    let foodName: String
    let category: String
    let note: String
    let detailImage: UIImage?
    let authorImage: UIImage?

    var likesTotal: Int
    var isLike  = false
    let detailImageKey: String
    let authorImageKey: String

    init(name: String, userName: String, foodName: String, category: String,
         isLike: Bool, note: String, likesTotal: Int, detailImage: UIImage,
         authorImage: UIImage) {
        self.name = name
        self.userName = userName
        self.foodName = foodName
        self.category = category
        self.isLike = isLike
        self.note = note
        self.likesTotal = likesTotal
        detailImageKey = NSUUID().UUIDString
        authorImageKey = NSUUID().UUIDString
        self.detailImage = detailImage
        self.authorImage = authorImage

        /* cache.setImage(
            UIImageJPEGRepresentation(detailImage, 0.6)!, key: detailImageKey)
        cache.setImage(
            UIImageJPEGRepresentation(authorImage, 0.6)!, key: authorImageKey) */
    }

    func updateLike(inc: Bool) {
        if inc {
            likesTotal += 1
        } else {
            likesTotal -= 1
        }
    }
}