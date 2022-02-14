//
//  PairConversionViewModel.swift
//  ExchangeRate
//
//  Created by Teerawat Vanasapdamrong on 14/2/2565 BE.
//

import Foundation

enum SelectingCode {
    case base
    case target
}

class PairConversionViewModel {
    private var apiManager: APIManagerProtocol
    private var isLoading = false
    var rateDidUpdate: (() -> Void)?
    var baseDidUpdate: ((String) -> Void)?
    var targetDidUpdate: ((String) -> Void)?
    var didFail: ((Error) -> Void)?
    
    private var baseCode: String = "THB"
    private var targetCode: String = "SGD"
    private var rate: Double = 1 {
        didSet {
            rateDidUpdate?()
        }
    }
    var selectingCode: SelectingCode?
    
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    func getPairConversion() {
        if isLoading {
            return
        }
        isLoading = true
        
        APIManager().getPairConversion(baseCode: baseCode, targetCode: targetCode) { [weak self] result in
            switch result {
            case .success(let response):
                self?.rate = response.conversionRate
            case .failure(let error):
                self?.didFail?(error)
            }
            self?.isLoading = false
        }
    }
    
    func swap(targetString: String?) {
        let temp = targetCode
        targetCode = baseCode
        baseCode = temp
        rate = 1 / rate
        calculateTarget(baseString: targetString)
    }
    
    func updateCode(code: String) {
        if selectingCode == .base {
            baseCode = code
        } else {
            targetCode = code
        }
    }
    
    func calculateBase(targetString: String?) {
        guard let targetString = targetString, let targetAmount = Double(targetString) else {
            return
        }
        let baseAmount = targetAmount / rate
        baseDidUpdate?(String(format: "%.2f", baseAmount))
    }
    
    func calculateTarget(baseString: String?) {
        guard let baseString = baseString, let baseAmount = Double(baseString) else {
            return
        }
        let targetAmount = baseAmount * rate
        targetDidUpdate?(String(format: "%.2f", targetAmount))
    }
    
    func baseText() -> String {
        return "\(baseCode), \(DataInstance.shared.getDescriptionFor(code: baseCode))"
    }
    
    func targetText() -> String {
        return "\(targetCode), \(DataInstance.shared.getDescriptionFor(code: targetCode))"
    }
}
