//
//  PortfolioTableViewCell.swift
//  UpstockUIKit
//
//  Created by Mindstix on 21/02/22.
//

import UIKit

class PortfolioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var portfolioHoldingLabel: UILabel!
    @IBOutlet weak var portfolioTitleLabel: UILabel!
    @IBOutlet weak var portfolioProfitLossLabel: UILabel!
    @IBOutlet weak var portfolioLTPLabel: UILabel!
    @IBOutlet weak var portfolioNetQuantityLabel: UILabel!
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    var cellViewModel: PortfolioCellViewModel? {
            didSet {
                portfolioHoldingLabel.text = cellViewModel?.portfolioHoldingLabel
                portfolioTitleLabel.text = cellViewModel?.portfolioTitleLabel
                portfolioNetQuantityLabel.text = cellViewModel?.portfolioNetQuantityLabel
                portfolioLTPLabel.text = "₹\(cellViewModel?.portfolioLTPLabel ?? "")"
                
                let value = Double(cellViewModel?.portfolioProfitLossLabel ?? "")
                if ((value?.sign) == .minus) { portfolioProfitLossLabel.textColor = UIColor.red }
                else { portfolioProfitLossLabel.textColor = UIColor.systemGreen }
                portfolioProfitLossLabel.text = "₹\(cellViewModel?.portfolioProfitLossLabel ?? "")"
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.awakeFromNib()
        initView()
    }
    
    func initView() {
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        portfolioHoldingLabel.text = nil
        portfolioTitleLabel.text = nil
        portfolioProfitLossLabel.text = nil
        portfolioLTPLabel.text = nil
        portfolioNetQuantityLabel.text = nil
    }
    
}
