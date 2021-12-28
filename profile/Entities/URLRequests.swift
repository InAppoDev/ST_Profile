//
//  STUrls.swift
//  swim-training
//
//  Created by Alexandr on 04.11.2021.
//

import Foundation

enum URLRequests: String {
	case baseUrl
	case baseMediaUrl
	case searchFriend
	case addFriend
	case getFriends
	case profileData
}

extension URLRequests {
	var rawValue: String {
		switch self {
		case .baseUrl:
			return "http://188.227.16.13/api/v3/"
		case .baseMediaUrl:
			return "http://188.227.16.13"
		case .searchFriend:
			return URLRequests.baseUrl.rawValue + "accounts/friends/search/"
		case .addFriend:
			return URLRequests.baseUrl.rawValue + "accounts/friends/"
		case .getFriends:
			return URLRequests.baseUrl.rawValue + "accounts/friends/"
		case .profileData:
			return URLRequests.baseUrl.rawValue + "accounts/account/"

		}
	}
}
