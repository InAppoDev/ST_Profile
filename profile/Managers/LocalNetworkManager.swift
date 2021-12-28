//
//  LocalNetworkManager.swift
//  profile
//
//  Created by Alexandr on 28.12.2021.
//


import Foundation
import Alamofire

class LocalNetworkManager {
	static let shared = LocalNetworkManager()
	
	private init() {}
	
	private let networkManager = NetworkManager.shared

	//MARK: Search Friend
	func searchFriend(page: Int, text: String, token: String, completion: @escaping (InfoFriend?, CustomErrors?) -> Void) {
		let urlString = URLRequests.searchFriend.rawValue + "?page=\(page)" + "&q=\(text)"
		let headers: HTTPHeaders = ["Content-Type": "accept: application/json", "Authorization": token]
		
		networkManager.fetchData(urlString: urlString, method: .get, headers: headers) { result, error in
			completion(result, error)
		}
	}
	
	//MARK: - Add Friend
	func addFriend(userID: Int, token: String, completion: @escaping (AddFriendResponse?, CustomErrors?) -> Void) {
		let parameters = ["friend" : userID]
		let headers: HTTPHeaders = ["Authorization": token]
		
		networkManager.fetchData(urlString: URLRequests.addFriend.rawValue, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers) { result, error in
			completion(result, error)
		}
	}

	//MARK: - Get Friends
	func getFriends(page: Int, token: String, completion: @escaping (InfoFriend?, CustomErrors?) -> Void) {
		let urlString = URLRequests.getFriends.rawValue + "?page=\(page)"
		let headers: HTTPHeaders = ["Content-Type": "accept: application/json", "Authorization": token]
		
		networkManager.fetchData(urlString: urlString, method: .get, headers: headers) { result, error in
			completion(result, error)
		}
	}

	//MARK: - Get Profile Data
	func getProfileData(token: String, language: String, accountID: Int, completion: @escaping (UserData?, CustomErrors?) -> Void) {
		let urlString = URLRequests.profileData.rawValue + "\(accountID)/"
		let headers: HTTPHeaders = ["Content-Type": "accept: application/json", "Accept-Language": language, "Authorization": token]
		
		networkManager.fetchData(urlString: urlString, method: .get, headers: headers) { result, error in
			completion(result, error)
		}
		
	}
	
	//MARK: - Pud User Data
	func putUserData(data: UserProfileDataPut, token: String, language: String, accountID: Int, completion: @escaping (UserProfileDataGet?, CustomErrors?) -> Void) {
		let urlString = URLRequests.profileData.rawValue + "\(accountID)/"
		let headers: HTTPHeaders = ["Accept-Language": language, "Authorization": token]
		
		networkManager.fetchData(urlString: urlString, method: .put, parameters: data, encoder: JSONParameterEncoder.default, headers: headers) { result, error in
			completion(result, error)
		}
		
	}
	
}

