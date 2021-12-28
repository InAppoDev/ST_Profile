//
//  ResponseError.swift
//  swim-training
//
//  Created by Alexandr on 15.11.2021.
//

import UIKit
import Alamofire

enum CustomErrors: Error {
	case noInternet
	case error
	case unauthorizedRequest

}

extension CustomErrors {
	var description: String {
		switch self {

		case .noInternet:
			return "NoInternet".localizeString
		case .error:
			return "Error".localizeString
		case .unauthorizedRequest:
			return "AuthError".localizeString
		}
	}
}

//MARK: - Return Error
extension CustomErrors {
	static func returnError(response: HTTPURLResponse?, error: AFError?) -> CustomErrors? {
		if let error = error?.underlyingError as? URLError {
			if error.errorCode == -1009 || error.errorCode == -1004 {
				return CustomErrors.noInternet
			}
		} else if response?.statusCode == 401 {
				return CustomErrors.unauthorizedRequest
		}
		return nil
	}
}
