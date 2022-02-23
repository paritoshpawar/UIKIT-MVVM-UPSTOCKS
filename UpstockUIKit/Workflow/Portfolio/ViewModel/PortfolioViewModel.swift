//
//  PortfolioViewModel.swift
//  UpstockUIKit
//
//  Created by Mindstix on 21/02/22.
//

import Foundation

class PortfolioViewModel : NSObject {
    
    //MARK: Class Variables
    private var portfolioService: PortfolioServiceProtocol
    
    var reloadTableView: (() -> Void)?
    var portfolioData = [PortfolioData]()
    var portfolioCellViewModels = [PortfolioCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    //MARK: Class Variables to calculate the BottomView data
    var currentValue : Double = 0.0
    var totalInvestment: Double = 0.0
    var totalProfitLoss: Double = 0.0
    var todaysProfitLoss: Double = 0.0
    var totalProfitLossPercentage: Double = 0.0
    
    //MARK: Class Initilizers
    init(portfolioService: PortfolioServiceProtocol = PortfolioService()) {
        self.portfolioService = portfolioService
    }
    
    //MARK: get protfolio data API call
    func getPortfolioData() {
        portfolioService.getPortfolioData { success, results, error in
            if success, let portfolioData = results {
                self.fetchData(portfolioItemData: portfolioData.data)
            } else {
                print(error!)
            }
        }
    }
    
    //MARK: Fetch data to create Cell viewModel
    func fetchData(portfolioItemData : [PortfolioData]) {
        self.portfolioData = portfolioItemData // Cache
        var vms = [PortfolioCellViewModel]()
        calculateBottomViewValues(portfolioItemData: portfolioItemData)
        for item in portfolioData {
            vms.append(createCellModel(portfolioData: item))
        }
        portfolioCellViewModels = vms
    }
    
    //MARK: Calculations for bottom View
    //        Rules:
    //        1. Current value = sum of (Last traded price * quantity of holding ) of all the holdings
    //        2. Total investment = sum of (Average Price * quantity of holding ) of all the holdings
    //        3. Total PNL = Current value - Total Investment
    //        4. Today’s PNL = sum of ((Close - LTP ) * quantity) of all the holdings
    func calculateBottomViewValues(portfolioItemData : [PortfolioData]) {
        
        var tempCurrentValue: Double = 0
        var tempTotalInvestment: Double = 0
        var tempTodaysPNL: Double = 0
        
        for item in portfolioData {
            tempCurrentValue += (Double(item.quantity) * item.ltp)
            let avgPrice = Double(item.avgPrice) ?? 0.0
            tempTotalInvestment += (Double(item.quantity) * avgPrice)
            
            tempTodaysPNL += (item.close - item.ltp) * Double(item.quantity)
        }
        self.currentValue = tempCurrentValue.rounded(toPlaces: 2)
        self.totalInvestment = tempTotalInvestment.rounded(toPlaces: 2)
        self.totalProfitLoss = self.currentValue - self.totalInvestment
        self.todaysProfitLoss = tempTodaysPNL.rounded(toPlaces: 2)
        self.totalProfitLossPercentage = ((100 * totalProfitLoss) / totalInvestment).rounded(toPlaces: 2)
    }
    
    // MARK: Create cell model with data fields
    func createCellModel(portfolioData: PortfolioData) -> PortfolioCellViewModel {
        let companyName = portfolioData.symbol
        let ltpData = "\(portfolioData.ltp)"
        let qtyData = "\(portfolioData.quantity)"
        let holdingLabel = ""
        let value = self.getProfitAndLoss(ltp: portfolioData.ltp, avg: Double(portfolioData.avgPrice) ?? 0.0, qty: Double(portfolioData.quantity))
        let profitLossData = "\(value)"
        
        return PortfolioCellViewModel(portfolioTitleLabel: companyName, portfolioProfitLossLabel: profitLossData, portfolioLTPLabel: ltpData, portfolioNetQuantityLabel: qtyData, portfolioHoldingLabel: holdingLabel)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> PortfolioCellViewModel {
        return portfolioCellViewModels[indexPath.row]
    }
    
    func getProfitAndLoss (ltp : Double, avg : Double, qty : Double ) -> Double {
        let value = ((ltp * qty) - (avg * qty))
        return value.rounded(toPlaces: 2)
    }
}

// MARK: Extension to round of double value
extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
