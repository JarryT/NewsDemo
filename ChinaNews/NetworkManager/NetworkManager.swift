//
//  NetworkManager.swift
//  Swifter
//
//  Created by 汤军 on 2019/6/26.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

let ShareNetworkManager = NetworkManager()

struct NetworkManager: NetworkClient {
    var baseUrlAvailable = false
    var host: String = API_BASE_URL.absoluteString
    func send<T>(_ r: T, completionHandler: @escaping (T.Response?, NetworkError?) -> Void) where T : NetworkRequest {
        //sorted
        let sortedParams = r.parameter.sorted { (arg1, arg2) -> Bool in
            return arg1.key < arg2.key
        }
        var urlString = ""
        var signString = ""
        var parameter: [String : String] = [String : String]()
        for item in sortedParams {
            parameter[item.key] = item.value
            signString += item.key + item.value
            urlString += "\(item.key)=\(item.value)&"
        }
        signString += "28003da34fcb4e5298fe649655f274c2"
        urlString += "showapi_sign=\(signString.hashed(.md5)!)"
        urlString = r.path + "?" + urlString
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = r.method.rawValue
        let json = JSON.init(sortedParams)
        request.httpBody = try? json.rawData(options: .prettyPrinted)
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let err = error {
                DispatchQueue.main.async { completionHandler(nil, NetworkError.requestError(description: err.localizedDescription)) }
            }
            if let jsonData = data, let json = try? JSON(data: jsonData) {
                let code = json["showapi_res_code"].intValue
                if code == 0 {
                    let body = json["showapi_res_body"]
                    let res = T.Response.parse(data: body)
                    DispatchQueue.main.async { completionHandler(res, nil) }
                } else {
                    let errorDescription = json["showapi_res_error"].stringValue
                    DispatchQueue.main.async { completionHandler(nil, NetworkError.requestError(description: errorDescription)) }
                }
            } else {
                DispatchQueue.main.async { completionHandler(nil, NetworkError.requestError(description: "data error")) }
            }
        }
        task.resume()
    }
}

