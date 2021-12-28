//
//  UserDataView.swift
//  swim-training
//
//  Created by Alexandr on 06.12.2021.
//

import UIKit

class UserDataView: ViewFromXib {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var textField: CustomTextField!
	
	
	func configureLocalization(name: String, description: String) {
		
		nameLabel.text = name.localizeString
		descriptionLabel.text = description.localizeString
	}
	
	func configureDelegate(delegate: UITextFieldDelegate, tag: Int) {
		
		textField.delegate = delegate
		textField.tag = tag
		
	}
}
