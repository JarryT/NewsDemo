//
//  Network.swift
//  Swifter
//
//  Created by 汤军 on 2019/6/26.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

enum NetworkError: Error, Equatable {
    case  requestError(description: String?)
}

enum NetworkMethod: String {
    case GET = "GET"
    case POST = "POST"
}

protocol NetworkRequest {
    var path: String { get }
    var method: NetworkMethod { get }
    var parameter: [String: String] { get set}

    associatedtype Response: NetworkParsable
}

extension NetworkRequest {

    mutating func addParameter(_ parameter: [String: String]) {
        for item in parameter {
            if item.value.count > 0 {
                self.parameter[item.key] = item.value
            }
        }
    }

    var headers: [String: String] {
        return ["a":"aaa"]
    }
}

protocol NetworkParsable {
    static func parse(data: JSON) -> Self?
}

protocol NetworkClient {
    func send<T: NetworkRequest>(_ r: T, completionHandler: @escaping (T.Response?, NetworkError?) -> Void)
    var host: String { get }
}




