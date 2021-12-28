//
//  UserPofile.swift
//  swim-training
//
//  Created by Alexandr on 07.12.2021.
//

import Foundation

struct UserProfileDataPut: Codable {
	var id: Int?
	var firstname, lastname: String?
	var gender, age, height, currentWeight: Int?
	var targetWeight: Int?
	var photo: String
	
	enum CodingKeys: String, CodingKey {
		case id, firstname, lastname, gender, age, height
		case currentWeight = "current_weight"
		case targetWeight = "target_weight"
		case photo
	}
}

struct UserProfileDataGet: Codable {
	var id: Int?
	var firstname, lastname: String?
	var gender, age, height, currentWeight: Int?
	var targetWeight: Int?
	var photoURL: String
	
	enum CodingKeys: String, CodingKey {
		case id, firstname, lastname, gender, age, height
		case currentWeight = "current_weight"
		case targetWeight = "target_weight"
		case photoURL = "photo_url"
	}
}
