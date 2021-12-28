//
//  AwardCollectionViewCell.swift
//  swim-training
//
//  Created by Alexandr on 06.12.2021.
//

import UIKit

class AwardCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var awardView: AwardView!
	
	func configureCell(title: String, iconURL: String) {
		awardView.configureAward(title: title, iconURL: iconURL)
	}
}
