//
//  RestaurantTableViewCell.swift
//  EatLike
//
//  Created by Queen Y on 16/3/11.
//  Copyright © 2016年 Queen. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var LocationLabel: UILabel!
	@IBOutlet weak var TypeLabel: UILabel!
	@IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		// Configure the view for the selected state
	}

	func updateLabelPerferredFont() {
		let headFont = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
		let captionFont = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
		let subFont = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)

		nameLabel.font = headFont
		LocationLabel.font = subFont
		TypeLabel.font = captionFont
	}

    func configure(data: Restaurant) {
        let cache = (UIApplication.sharedApplication().delegate as! AppDelegate).imageCache
        nameLabel.text = data.name
        LocationLabel.text = data.location
        TypeLabel.text = data.type
        thumbnailImageView.image = cache.imageForKey(data.keyString)
        updateLabelPerferredFont()

        /* 给 缩略图添加圆角效果
         但是可以使用 IB 来完成这个任务。
         通过添加 Runtime Attribute 设置半径（为图片框架的长度的一半，半径）
         再设置 imageView 的 Attribute 的  Clip Subviews */
        // cell.thumbnailImageView.layer.cornerRadius = 30.0
        // cell.thumbnailImageView.clipsToBounds = true

    }

    func addNoteView(noteview: UIView) {
        noteview.heightAnchor.constraintEqualToConstant(80).active = true
        stackView.addArrangedSubview(noteview)
    }

    func removeNoteView(noteView: UIView) {
        stackView.removeArrangedSubview(noteView)
        noteView.removeFromSuperview()
    }

}
