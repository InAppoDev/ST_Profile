//
//  STProfileViewController.swift
//  swim-training
//
//  Created by Alexandr on 11.11.2021.
//

import UIKit
import SDWebImage

class STProfileViewController: UIViewController {

	@IBOutlet weak var profileImage: UIImageView!
	
	@IBOutlet weak var distanceLabel: UILabel!
	@IBOutlet weak var distanceTitle: UILabel!
	
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var timeTitle: UILabel!
	
	@IBOutlet weak var kcalLabel: UILabel!
	@IBOutlet weak var kcalTitle: UILabel!
	
	@IBOutlet weak var myDataButtonOutlet: GradientButton!
	@IBOutlet weak var myFriendsButtonOutlet: GradientButton!
	
	@IBOutlet weak var footerView: ViewWithThineLine!
	@IBOutlet weak var awardView: AwardView!
	
	@IBOutlet weak var awardViewTwo: AwardView!
		
	@IBOutlet weak var allAwardsButtonOutlet: GradientButton!

	
	private var userData: UserData?
	private var userProfileData: UserProfileDataPut?
	private var rewardsData: [RewardElement] = []
	
	var photoURL: String? {
		didSet {
			if let photoURL = photoURL {
				userProfileData?.photo = photoURL
				setProfileImage(photoURL: photoURL)
			} else {
				userProfileData?.photo = ""
				profileImage.isHidden = true
			}
		}
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		
		profileImage.isHidden = true
		awardView.isHidden = true
		awardViewTwo.isHidden = true
		
		configureNavigationBar()
		configureLocalization()
		configureNavigationItem()
		getUserData()
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		configureGradient()
	}
	
	private func configureNavigationBar() {
		let appearance = UINavigationBarAppearance()
		appearance.backgroundColor = UIColor(red: 202/255, green: 13/255, blue: 94/255, alpha: 1)
		appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		navigationController?.navigationBar.compactAppearance = appearance
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.scrollEdgeAppearance = appearance
		navigationController?.navigationBar.tintColor = .white
	}

	private func configureNavigationItem() {
		navigationController?.navigationBar.tintColor = .white
		let backItem = UIBarButtonItem()
		backItem.title = "BackButtonTitle".localizeString
		navigationItem.backBarButtonItem = backItem
	}
	
	private func configureGradient() {
		let topColor = Constats.Colors.topGradientColor
		let bottomColor = Constats.Colors.bottomGradientColor
		myDataButtonOutlet.applyGradient(topColor: topColor, bottomColor: bottomColor)
		myFriendsButtonOutlet.applyGradient(topColor: topColor, bottomColor: bottomColor)
	}
	
	private func configureAwards() {
		guard self.rewardsData.count >= 2 else { return }
		let firstReward = self.rewardsData[0]
		let secondReward = self.rewardsData[1]
		
		awardView.configureAward(title: firstReward.reward.name, iconURL: firstReward.reward.iconURL)
		awardViewTwo.configureAward(title: secondReward.reward.name, iconURL: secondReward.reward.iconURL)
	}
	
	private func configureResultElements() {
		guard let userData = userData else { return }

		let value = userData.totalTrainingKM
		let string = String(format: "%.2f", value)
		let replacingString = string.replacingOccurrences(of: ".", with: ",")
		
		timeLabel.text = TimeManager.shared.getTimeString(seconds: userData.totalTrainingSeconds)
		
		let distanceString = replacingString
		distanceLabel.text = distanceString
		
		kcalLabel.text = "\(userData.totalTrainingKcal)"

		setProfileImage(photoURL: userData.photoURL)
		
	}
	
	private func setProfileImage(photoURL: String) {
		let imageStringURL = URLRequests.baseMediaUrl.rawValue + photoURL
		profileImage.sd_setImage(with: URL(string: imageStringURL)) { [weak self] image, _, _, _ in
			if image == nil {
				self?.profileImage.isHidden = true
			} else {
				self?.profileImage.isHidden = false
			}
		}
	}
	
	func getUserData() {
		guard let token = UserManager.shared.userToken, let accountID = UserManager.shared.userAccountID else { return }
		SpiningManager.shared.startIndicator()
		
		LocalNetworkManager.shared.getProfileData(token: token, language: Constats.Language.systemLanguage, accountID: accountID) { [weak self] result, error in
			SpiningManager.shared.stopIndicator()
			
			if let result = result {
				self?.userData = result
				self?.splitData()
				self?.configureResultElements()
			} else {
				self?.showErrorAlert(error: error)
			}
		}
	}
	
	private func splitData() {
		guard let userData = userData else { return }

		self.userProfileData = UserProfileDataPut(id: userData.id, firstname: userData.firstname, lastname: userData.lastname, gender: userData.gender, age: userData.age, height: userData.height, currentWeight: userData.currentWeight, targetWeight: userData.targetWeight, photo: userData.photoURL)
		
		self.rewardsData = userData.rewards
		configureAwards()
		
		if self.rewardsData.count < 2 {
			self.awardView.isHidden = true
			self.awardViewTwo.isHidden = true
		} else {
			self.awardView.isHidden = false
			self.awardViewTwo.isHidden = false
		}
	}
	
	@IBAction func myDataTapped(_ sender: GradientButton) {
		let vc = STUserDataViewController()
		vc.userProfileData = userProfileData
		
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	@IBAction func myFriendsTapped(_ sender: GradientButton) {
		let vc = STFriendsViewController()
		vc.hidesBottomBarWhenPushed = true
		
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	@IBAction func allAwardsTapped(_ sender: GradientButton) {
		let vc = STAllAwardsViewController()
		vc.rewardsData = self.rewardsData
		self.navigationController?.pushViewController(vc, animated: true)
	}
}

//MARK: - Configure Localization
extension STProfileViewController {
	private func configureLocalization() {
		title = "ProfileTitle".localizeString
		
		distanceTitle.text = "DistanceTitle".localizeString
		timeTitle.text = "TimeTitle".localizeString
		kcalTitle.text = "CaloriesTitle".localizeString
		myDataButtonOutlet.setTitle("MyDataButtonTitle".localizeString, for: .normal)
		myFriendsButtonOutlet.setTitle("MyFriendsButtonTile".localizeString, for: .normal)
		
		footerView.dateLabel.text = "AwardsTitle".localizeString
		footerView.dateLabel.textColor = UIColor(red: 203/255, green: 11/255, blue: 69/255, alpha: 1)
		
		allAwardsButtonOutlet.setTitle("AllAwardsButtonTitle".localizeString, for: .normal)
	}
}
