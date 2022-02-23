//
//  PortfolioViewController.swift
//  UpstockUIKit
//
//  Created by Mindstix on 21/02/22.
//

import UIKit

class PortfolioViewController: UIViewController {
    
    
    // MARK: Class IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomViewTodayProfitLoss: UILabel!
    @IBOutlet weak var profitLossLabel: UILabel!
    @IBOutlet weak var bottomViewTotalInvestment: UILabel!
    @IBOutlet weak var totalInvestmentLabel: UILabel!
    @IBOutlet weak var bottomViewCurrentValue: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var bottomViewChevron: UIImageView!
    @IBOutlet weak var bottomViewSeperator: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomExpandableView: UIView!
    @IBOutlet weak var profitLossPercentage: UILabel!
    @IBOutlet weak var totalProfitLoss: UILabel!
    
    // MARK: ViewModel variable
    lazy var viewModel = {
        PortfolioViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    func initView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.register(PortfolioTableViewCell.nib, forCellReuseIdentifier: PortfolioTableViewCell.identifier)
        
        self.showHideBottomView(BoolValue: true)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        bottomExpandableView.addGestureRecognizer(tap)
        bottomExpandableView.isUserInteractionEnabled = true
        self.view.addSubview(bottomExpandableView)
        
    }
    
    func initViewModel() {
        viewModel.getPortfolioData()
        bottomExpandableView.layer.cornerRadius = 5;
        bottomExpandableView.layer.masksToBounds = true;
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.setBottomViewValues()
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: Setup Bottom view UI
    func showHideBottomView(BoolValue : Bool) {
        
        currentValueLabel.isHidden = BoolValue
        bottomViewCurrentValue.isHidden = BoolValue
        totalInvestmentLabel.isHidden = BoolValue
        bottomViewTotalInvestment.isHidden = BoolValue
        bottomViewTodayProfitLoss.isHidden = BoolValue
        profitLossLabel.isHidden = BoolValue
        bottomViewSeperator.isHidden = BoolValue
    }
    
    // MARK: Setup Bottom view with values
    func setBottomViewValues() {
        
        bottomViewTodayProfitLoss.text = "₹\(viewModel.todaysProfitLoss)"
        bottomViewCurrentValue.text = "₹\(viewModel.currentValue)"
        bottomViewTotalInvestment.text = "₹\(viewModel.totalInvestment)"
        totalProfitLoss.text = "₹\(viewModel.totalProfitLoss)"
        profitLossPercentage.text = "(\(viewModel.totalProfitLossPercentage)%)"
        
        if ((viewModel.todaysProfitLoss.sign) == .minus) { bottomViewTodayProfitLoss.textColor = UIColor.red }
        else { bottomViewTodayProfitLoss.textColor = UIColor.systemGreen }
        
        if ((viewModel.totalProfitLoss.sign) == .minus) { profitLossPercentage.textColor = UIColor.red; totalProfitLoss.textColor = UIColor.red }
        else { profitLossPercentage.textColor = UIColor.systemGreen; totalProfitLoss.textColor = UIColor.systemGreen }
    }
        
    // MARK: Expand/Collapse Action on Bottomview click
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            if(self.bottomViewHeight.constant == 48)
            {
                self.showHideBottomView(BoolValue: false)
                UIView.animate(
                    withDuration: 1.5, delay: 0, options: .curveEaseIn,
                    animations: {
                        self.bottomViewChevron.image = UIImage(systemName: "chevron.down")
                        self.bottomViewHeight.constant = 160
                    })
            }
            else
            {
                self.showHideBottomView(BoolValue: true)
                UIView.animate(
                    withDuration: 1.5, delay: 0, options: .curveEaseIn,
                    animations: {
                        self.bottomViewChevron.image = UIImage(systemName: "chevron.up")
                        self.bottomViewHeight.constant = 48
                    })
            }
        }
    }
}

// MARK: Table view delegate extension
extension PortfolioViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: Table view data Source extension
extension PortfolioViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.portfolioCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioTableViewCell", for: indexPath) as? PortfolioTableViewCell else { fatalError("xib does not exists") }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
}
