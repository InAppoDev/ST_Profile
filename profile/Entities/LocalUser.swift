//
//  LocalUser.swift
//  swim-training
//
//  Created by Developer on 02.11.2021.
//

import Foundation

struct LocalUser: Codable {
	let token: String
	let accountID: Int

	enum CodingKeys: String, CodingKey {
		case token
		case accountID = "account_id"
	}
}
