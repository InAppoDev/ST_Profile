//
//  UserData.swift
//  swim-training
//
//  Created by Alexandr on 07.12.2021.
//

import Foundation

// MARK: - UserProfile
struct UserData: Codable {
	let id: Int
	let firstname, lastname: String?
	let gender, age, height, currentWeight: Int?
	let targetWeight: Int?
	let photoURL: String
	let totalTrainingKcal: Int
	let totalTrainingKM: Double
	let totalTrainingSeconds: Int
	let rewards: [RewardElement]

	enum CodingKeys: String, CodingKey {
		case id, firstname, lastname, gender, age, height
		case currentWeight = "current_weight"
		case targetWeight = "target_weight"
		case photoURL = "photo_url"
		case totalTrainingKcal = "total_training_kcal"
		case totalTrainingKM = "total_training_km"
		case totalTrainingSeconds = "total_training_seconds"
		case rewards
	}
}

// MARK: - RewardElement
struct RewardElement: Codable {
	let reward: RewardReward
	let rewardDate: String

	enum CodingKeys: String, CodingKey {
		case reward
		case rewardDate = "reward_date"
	}
}

// MARK: - RewardReward
struct RewardReward: Codable {
	let id: Int
	let name, iconURL: String

	enum CodingKeys: String, CodingKey {
		case id, name
		case iconURL = "icon_url"
	}
}

