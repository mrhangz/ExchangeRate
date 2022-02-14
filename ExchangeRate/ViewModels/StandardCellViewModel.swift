//
//  StandardCellViewModel.swift
//  ExchangeRate
//
//  Created by Teerawat Vanasapdamrong on 12/2/2565 BE.
//

import Foundation

struct StandardCellViewModel {
    private let code: String!
    private let rate: Double!
    
    init(code: String, rate: Double) {
        self.code = code
        self.rate = rate
    }
    
    func displayingCode() -> String {
        return code
    }
    
    func displayingRate() -> String {
        return String(format: "%.2f", rate)
    }
}
