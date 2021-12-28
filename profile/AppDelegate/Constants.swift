//
//  Constants.swift
//  profile
//
//  Created by Alexandr on 28.12.2021.
//

import UIKit

struct Constats {
	struct Purchase {
		static let sharedSecret = "a02aebfb3177474cb34a375839068929"
		static let monthSubscriptionID = "yorich.fitness.monthly.new"
		static let yearSubscriptionID = "yorich.fitness.yearly.new"
	}
	
	struct GoogleSigIn {
		static let clientID = "1083839777608-1vc85gna7c69j12rvgqn7c3eaaqeg3pe.apps.googleusercontent.com"
		static let serverClientID = "1083839777608-v0bqn6knuu92sdv2hkc25qlud5a15jdc.apps.googleusercontent.com"
	}
	
	struct Facebook {
		static let appID = "472717030602557"
	}
	
	struct VK {
		static let appId = "7847525"
	}
	
	struct UserDefaultsKeys {
		static let userTrainingLevel = "UserTrainingLevel"
		static let userIsPremium = "userIsPremium"
		
		static let userSubscriptionIdentifier = "UserSubscriptionIdentifier"
	}
	
	struct Colors {
		static let topGradientColor: UIColor = UIColor(red: 190/255, green: 5/255, blue: 60/255, alpha: 1)
		static let bottomGradientColor: UIColor = UIColor(red: 233/255, green: 53/255, blue: 106/255, alpha: 1)
	}
	
	struct DateFormatter {
		static let dateFormat = "YY/MM/dd"
	}
	
	struct Language {
		static var systemLanguage: String {
			return NSLocale.current.languageCode ?? ""
		}
	}
}

