//
//  AwardView.swift
//  swim-training
//
//  Created by Alexandr on 03.12.2021.
//

import UIKit
import SDWebImage

class AwardView: ViewFromXib {

	@IBOutlet weak var imageAward: UIImageView!	
	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var titleAward: UILabel!
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		backgroundView.roundCorners(corners: [.topLeft, .topRight], radius: 2)
		self.roundCorners(corners: [.topLeft, .bottomLeft,  .topRight, .bottomRight], radius: 4)
	}
	
	func configureAward(title: String, iconURL: String) {
		self.titleAward.text = title
		
		let urlString = URLRequests.baseMediaUrl.rawValue + iconURL
		self.imageAward.sd_setImage(with: URL(string: urlString))
	}
}

