//
//  CodeCellViewModel.swift
//  ExchangeRate
//
//  Created by Teerawat Vanasapdamrong on 9/2/2565 BE.
//

import Foundation

struct CodeCellViewModel {
    private let code: [String]!
    
    init(code: [String]) {
        self.code = code
    }
    
    func displayingText() -> String {
        return "\(code[0]), \(code[1])"
    }
}
