//
//  STUserDataViewController.swift
//  swim-training
//
//  Created by Alexandr on 06.12.2021.
//

import UIKit
import SDWebImage

class STUserDataViewController: UIViewController {
	enum GenderType: Int {
		case male
		case female
	}

	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var removeButtonOutlet: UIButton!
	@IBOutlet weak var changeImageButtonOutlet: UIButton!
	

	@IBOutlet weak var firstNameView: UserDataView!
	@IBOutlet weak var lastNameView: UserDataView!
	@IBOutlet weak var genderView: UserDataView!
	@IBOutlet weak var ageView: UserDataView!
	@IBOutlet weak var heightView: UserDataView!
	@IBOutlet weak var weightView: UserDataView!
	@IBOutlet weak var wishWeightView: UserDataView!
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var saveButtonOutlet: GradientButton!
	@IBOutlet weak var logoutButtonOutlet: GradientButton!
	@IBOutlet weak var bottomTFConstraint: NSLayoutConstraint!
	
	var userProfileData: UserProfileDataPut?
//	var userProfileImage: UIImage?
	var userChangedImage: Bool = false
	var photoURL: String?
	
	private var genderType = GenderType(rawValue: 0)
	private var keyboardHeight = CGFloat()
	
	override func viewDidLoad() {
        super.viewDidLoad()

		navigationController?.delegate = self
		configureLocalization()
		configureTF()
		setUserData()
		beginKeyboardObserving()
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		configureUI()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		self.view.endEditing(true)
	}
	
	

	
	override func keyboardWillShow(withHeight keyboardHeight: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
		self.keyboardHeight = keyboardHeight
		
		bottomTFConstraint.constant = keyboardHeight - 70
		UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
			self.view.layoutIfNeeded()
		})

	}
	
	override func keyboardWillHide(withDuration duration: TimeInterval, options: UIView.AnimationOptions) {

		bottomTFConstraint.constant = 20
		UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
			self.view.layoutIfNeeded()
		})
	}

	private func setUserData() {
		guard let userProfileData = userProfileData else { return }
		
		firstNameView.textField.text = userProfileData.firstname
		lastNameView.textField.text = userProfileData.lastname
		
		let genderType = GenderType(rawValue: userProfileData.gender ?? 0)!
		var genderTypeString: String
		switch genderType {
		case .male:
			genderTypeString = "MaleTitle".localizeString
		case .female:
			genderTypeString = "FemaleTitle".localizeString
		}
		genderView.textField.text = genderTypeString
		
		let ageString = (userProfileData.age != nil) ? "\(userProfileData.age!)" : ""
		ageView.textField.text = ageString
		
		let heightString = (userProfileData.height != nil) ? "\(userProfileData.height!)" : ""
		heightView.textField.text = heightString
		
		let currentWeightString = (userProfileData.currentWeight != nil) ? "\(userProfileData.currentWeight!)" : ""
		weightView.textField.text = currentWeightString
		
		let targetWeightString = (userProfileData.targetWeight != nil) ? "\(userProfileData.targetWeight!)" : ""
		wishWeightView.textField.text = targetWeightString

		let photoURL = userProfileData.photo
		let urlImageString = URLRequests.baseMediaUrl.rawValue + photoURL
		profileImage.contentMode = .scaleToFill
		profileImage.sd_setImage(with: URL(string: urlImageString)) { image, error, _, _ in
			if image == nil {
				//self.profileImage.image = UIImage(systemName: "photo.artframe")
				//self.profileImage.tintColor = .lightGray
				self.profileImage.image = UIImage(named: "man")
				self.profileImage.contentMode = .scaleAspectFit
			}
		}
	}
	
	private func configureUI() {
		removeButtonOutlet.layer.cornerRadius = removeButtonOutlet.frame.height / 2
		
		let topColor = Constats.Colors.topGradientColor
		let bottomColor = Constats.Colors.bottomGradientColor
		saveButtonOutlet.applyGradient(topColor: topColor, bottomColor: bottomColor)
		logoutButtonOutlet.applyGradient(topColor: topColor, bottomColor: bottomColor)
		
		let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
		let underlineAttributedString = NSAttributedString(string: changeImageButtonOutlet.titleLabel!.text!, attributes: underlineAttribute)
		changeImageButtonOutlet.setAttributedTitle(underlineAttributedString, for: .normal)
	}
		
	private func prepareDataForSend() {
		let firstNameString = firstNameView.textField.text
		let lastNameString = lastNameView.textField.text
		let ageString = ageView.textField.text ?? ""
		let heightString = heightView.textField.text ?? ""
		let currentWeightString = weightView.textField.text ?? ""
		let targetWeightString = wishWeightView.textField.text ?? ""

		userProfileData?.firstname = firstNameString
		userProfileData?.lastname = lastNameString
		userProfileData?.gender = genderType?.rawValue
		userProfileData?.age = Int(ageString) ?? nil
		userProfileData?.height = Int(heightString) ?? nil
		userProfileData?.currentWeight = Int(currentWeightString) ?? nil
		userProfileData?.targetWeight = Int(targetWeightString) ?? nil
		
		if let image = profileImage.image, let base64Encode = image.base64Encode(){
			userProfileData?.photo = base64Encode
		} else {
			userProfileData?.photo = ""
		}
	}
	
	private func saveData() {
		prepareDataForSend()
		
		guard let token = UserManager.shared.userToken, let accountID = UserManager.shared.userAccountID, let userProfileData = userProfileData else { return }
		SpiningManager.shared.startIndicator()
		
		LocalNetworkManager.shared.putUserData(data: userProfileData, token: token, language: Constats.Language.systemLanguage, accountID: accountID) { [weak self] result, error in
			SpiningManager.shared.stopIndicator()
			
			if let result = result {
				self?.navigationController?.popToRootViewController(animated: true)
				self?.photoURL = result.photoURL
			} else {
				self?.showErrorAlert(error: error)
			}
		}
	}
	
	@IBAction func saveButtonTapped(_ sender: GradientButton) {
		saveData()
	}
	
	@IBAction func logoutButtontapped(_ sender: GradientButton) {
		UserManager.shared.logout()
//		UIApplication.shared.windows.first?.rootViewController = STLoginViewController()
	}
	
	@IBAction func changeImageTapped(_ sender: UIButton) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePickerController.sourceType = .photoLibrary
		present(imagePickerController, animated: true, completion: nil)
	}
	
	@IBAction func removeImageTapped(_ sender: UIButton) {
		profileImage.image = nil
		userProfileData?.photo = ""
		self.userChangedImage = true
		saveData()
	}
}

//MARK: - TextFields
extension STUserDataViewController: UITextFieldDelegate {
	private func configureTF() {
		
		firstNameView.configureDelegate(delegate: self, tag: 1)
		lastNameView.configureDelegate(delegate: self, tag: 2)
		genderView.configureDelegate(delegate: self, tag: 3)
		ageView.configureDelegate(delegate: self, tag: 4)
		heightView.configureDelegate(delegate: self, tag: 5)
		weightView.configureDelegate(delegate: self, tag: 6)
		wishWeightView.configureDelegate(delegate: self, tag: 7)
		
		firstNameView.textField.returnKeyType = .next
		lastNameView.textField.returnKeyType = .next
		ageView.textField.keyboardType = .numberPad
		heightView.textField.keyboardType = .numberPad
		weightView.textField.keyboardType = .numberPad
		wishWeightView.textField.keyboardType = .numberPad
		
		setupToolbar(textField: ageView.textField)
		setupToolbar(textField: heightView.textField)
		setupToolbar(textField: weightView.textField)
		setupToolbar(textField: wishWeightView.textField)
		
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField.tag == 3 {
			let vc = GenderViewController()
			vc.genderDelegate = self
			vc.modalPresentationStyle = .fullScreen
			self.present(vc, animated: true, completion: nil)
		}
		
		if let tfView = self.view.viewWithTag(textField.tag + 10) {
			let xPosition = tfView.frame.minX
			var yPosition: CGFloat
			
			if tfView.tag == 11 {
				yPosition = tfView.frame.minY
			} else {
				//	midY = tfView.frame.midY - 250
				yPosition = tfView.frame.midY - (keyboardHeight / 3)
			}
			
			let frame = CGPoint(x: xPosition, y: yPosition)
			scrollView.setContentOffset(frame, animated: true)
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
			nextField.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
		}
		
		return false
	}
	
	func setupToolbar(textField: UITextField) {
		
		let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
		let nextButton = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action: #selector(nextTF))
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		
		bar.items = [flexSpace, flexSpace, nextButton]
		bar.sizeToFit()
		
		textField.inputAccessoryView = bar
		
	}
	
	@objc func nextTF() {
		if let firstResponder = view.window?.firstResponder as? UITextField {
			let _ = textFieldShouldReturn(firstResponder)
		}
	}
}

//MARK: - GenderViewControllerProtocol
extension STUserDataViewController: GenderViewControllerProtocol {
	func setGenderType(genderType: GenderType) {
		self.genderType = genderType
		
		switch genderType {
		case .male:
			genderView.textField.text = "MaleTitle".localizeString
		case .female:
			genderView.textField.text = "FemaleTitle".localizeString
		}
	}
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension STUserDataViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		picker.dismiss(animated: true, completion: nil)
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
		
		profileImage.image = image
		profileImage.contentMode = .scaleToFill
		self.userChangedImage = true
		saveData()
	}
	
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		if let navigationVC = viewController as? STProfileViewController {
			if userChangedImage && profileImage.image != nil {
				navigationVC.photoURL = photoURL
			} else if userChangedImage && profileImage.image == nil {
				navigationVC.photoURL = nil
			}
		}
	}
}

//MARK: - Localization
private extension STUserDataViewController {
	func configureLocalization() {
		firstNameView.configureLocalization(name: "NameTitle", description: "IndicateYourNameTitle")
		lastNameView.configureLocalization(name: "LastNameTitle", description: "IndicateYourLastNameTitle")
		genderView.configureLocalization(name: "MyGenderTitle", description: "IndicateYourGenderTitle")
		ageView.configureLocalization(name: "MyAgeTitle", description: "IndicateYourAgeTitle")
		heightView.configureLocalization(name: "MyHeightTitle", description: "IndicateYourHeightTitle")
		weightView.configureLocalization(name: "MyWeightTitle", description: "IndicateYourWeightTitle")
		wishWeightView.configureLocalization(name: "MyDesiredWeightTitle", description: "IndicateYourDesiredWeightTitle")
		
		title = "MyDataTitle".localizeString
		changeImageButtonOutlet.setTitle("ChangePhotoButtonTitle".localizeString, for: .normal)
		saveButtonOutlet.setTitle("SaveButtonTitle".localizeString, for: .normal)
		logoutButtonOutlet.setTitle("LogoutButtonTitle".localizeString, for: .normal)
	}
}


