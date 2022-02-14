//
//  StandardTableViewCell.swift
//  ExchangeRate
//
//  Created by Teerawat Vanasapdamrong on 12/2/2565 BE.
//

import UIKit

class StandardTableViewCell: UITableViewCell {
    @IBOutlet private weak var codeLabel: UILabel?
    @IBOutlet private weak var rateLabel: UILabel?
    var viewModel: StandardCellViewModel?
    
    func displayCell(viewModel: StandardCellViewModel) {
        self.viewModel = viewModel
        codeLabel?.text = viewModel.displayingCode()
        rateLabel?.text = viewModel.displayingRate()
    }
}
