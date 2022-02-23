//
//  PortfolioService.swift
//  UpstockUIKit
//
//  Created by Mindstix on 21/02/22.
//

import Foundation

protocol PortfolioServiceProtocol {
    func getPortfolioData(completion: @escaping (_ success: Bool, _ results: PortfolioModel?, _ error: String?) -> ())
}


// MARK: PortfolioService class to invoke the GET API call
class PortfolioService: PortfolioServiceProtocol {
    func getPortfolioData(completion: @escaping (Bool, PortfolioModel?, String?) -> ()) {
        HttpRequestHelper().GET(url: APIConstants.getPortfolioURL, params: ["": ""], httpHeader: .application_json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(PortfolioModel.self, from: data!)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse data to model")
                }
            } else {
                completion(false, nil, "Error: GET Request failed")
            }
        }
    }
}
