//
//  SearchTableViewCell.swift
//  ExchangeRate
//
//  Created by Teerawat Vanasapdamrong on 9/2/2565 BE.
//

import UIKit

class CodeTableViewCell: UITableViewCell {
    @IBOutlet private weak var label: UILabel?
    var viewModel: CodeCellViewModel?
    
    func displayCell(viewModel: CodeCellViewModel) {
        self.viewModel = viewModel
        label?.text = viewModel.displayingText()
    }
}
