//
//  GenderViewController.swift
//  swim-training
//
//  Created by Alexandr on 07.12.2021.
//

import UIKit

protocol GenderViewControllerProtocol: AnyObject {
	func setGenderType(genderType: STUserDataViewController.GenderType)
}

class GenderViewController: UIViewController {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var maleGenderButton: UIButton!
	@IBOutlet weak var femaleGenderButton: UIButton!
	@IBOutlet weak var backButtonOutlet: UIButton!
	
	weak var genderDelegate: GenderViewControllerProtocol?
	
	override func viewDidLoad() {
        super.viewDidLoad()

		configureLocalization()
    }

	private func configureLocalization() {
		titleLabel.text = "GenderTitle".localizeString
		maleGenderButton.setTitle("MaleTitle".localizeString, for: .normal)
		femaleGenderButton.setTitle("FemaleTitle".localizeString, for: .normal)
		backButtonOutlet.setTitle("BackButtonTitle".localizeString, for: .normal)
	}
	
	@IBAction func maleGenderTapped(_ sender: UIButton) {
		if let genderType = STUserDataViewController.GenderType(rawValue: sender.tag) {
			genderDelegate?.setGenderType(genderType: genderType)
		}
		
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func femaleGenderTapped(_ sender: UIButton) {
		if let genderType = STUserDataViewController.GenderType(rawValue: sender.tag) {
			genderDelegate?.setGenderType(genderType: genderType)
		}
		
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func backButtonTapped(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
}
