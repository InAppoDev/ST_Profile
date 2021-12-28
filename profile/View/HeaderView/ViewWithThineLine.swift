//
//  DateFooterView.swift
//  swim-training
//
//  Created by Alexandr on 25.11.2021.
//

import UIKit

class ViewWithThineLine: ViewFromXib {
	@IBOutlet weak var dateLabel: UILabel!

	func configureFooterView(value: Int) {
		dateLabel.text = DateManager.shared.getDateString(value: value)
	}
}
