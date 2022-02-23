//
//  PortfolioModel.swift
//  UpstockUIKit
//
//  Created by Mindstix on 18/02/22.
//

import Foundation

//typealias PortfolioItems = [PortfolioModel]

// MARK: - PortfolioModel 
struct PortfolioModel: Codable {
    let clientID: String
    let data: [PortfolioData]
    let error: String?
    let responseType: String
    let timestamp: Int

    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case data, error
        case responseType = "response_type"
        case timestamp
    }
}

// MARK: - Datum
struct PortfolioData: Codable {
    let avgPrice: String
    let cncUsedQuantity, collateralQty: Int
    let collateralType: String
    let collateralUpdateQty: Int
    let companyName: String
    let haircut: Double
    let holdingsUpdateQty: Int
    let isin, product: String
    let quantity: Int
    let symbol: String
    let t1HoldingQty: Int
    let tokenBse, tokenNse: String
    let withheldCollateralQty, withheldHoldingQty: Int
    let ltp, close: Double

    enum CodingKeys: String, CodingKey {
        case avgPrice = "avg_price"
        case cncUsedQuantity = "cnc_used_quantity"
        case collateralQty = "collateral_qty"
        case collateralType = "collateral_type"
        case collateralUpdateQty = "collateral_update_qty"
        case companyName = "company_name"
        case haircut
        case holdingsUpdateQty = "holdings_update_qty"
        case isin, product, quantity, symbol
        case t1HoldingQty = "t1_holding_qty"
        case tokenBse = "token_bse"
        case tokenNse = "token_nse"
        case withheldCollateralQty = "withheld_collateral_qty"
        case withheldHoldingQty = "withheld_holding_qty"
        case ltp, close
    }
}
