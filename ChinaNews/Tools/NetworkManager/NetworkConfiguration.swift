//
//  NetworkConfiguration.swift
//  Swifter
//
//  Created by 汤军 on 2019/6/26.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

struct NetworkConfiguration {
    enum API: String {
        case login = "1"
        case register = "2"
        case forgetPassword = "3"
        case checkEmail = "4"
        case resetPassword = "5"
        case userAgreement = "6"
    }
}

#if DEBUG || ADHOC
let ProductionEnvironmentKey = "ProductionEnvironmentKey"
let ProductionEnvironmentValue = UserDefaults.standard.bool(forKey: ProductionEnvironmentKey)
let API_BASE_URL = URL(string: ProductionEnvironmentValue ? "https://api.muchmatch.com" : "http://api.masonsoft.app")!
#else
let API_BASE_URL = URL(string: "https://api.muchmatch.com")!
#endif
