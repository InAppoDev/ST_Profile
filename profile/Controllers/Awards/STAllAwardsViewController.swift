//
//  STAllAwardsViewController.swift
//  swim-training
//
//  Created by Alexandr on 06.12.2021.
//

import UIKit

class STAllAwardsViewController: UIViewController {

	@IBOutlet weak var collectionView: UICollectionView!
	
	private let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
	private let itemsPerRow: CGFloat = 2
	
	var rewardsData: [RewardElement] = []
	override func viewDidLoad() {
        super.viewDidLoad()

        configureCollection()
		title = "AwardsTitle".localizeString
    }
	
	private func configureCollection() {
		let nibName = String(describing: AwardCollectionViewCell.self)
		let nib = UINib(nibName: nibName, bundle: nil)
		collectionView.register(nib, forCellWithReuseIdentifier: "awardCell")
		
	}
}

//MARK: - UICollectionViewDataSource
extension STAllAwardsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return rewardsData.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "awardCell", for: indexPath) as! AwardCollectionViewCell

		let reward = rewardsData[indexPath.row]
		cell.configureCell(title: reward.reward.name, iconURL: reward.reward.iconURL)
		
		return cell
	}
}

//MARK: - UICollectionViewDelegateFlowLayout
extension STAllAwardsViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / itemsPerRow
		
		return CGSize(width: widthPerItem, height: widthPerItem + 50)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return sectionInsets
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return sectionInsets.left
	}
}
