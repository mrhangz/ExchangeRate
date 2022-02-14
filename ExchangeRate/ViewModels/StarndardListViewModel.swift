//
//  StarndardListViewModel.swift
//  ExchangeRate
//
//  Created by Teerawat Vanasapdamrong on 14/2/2565 BE.
//

import Foundation

class StandardListViewModel {
    private var apiManager: APIManagerProtocol
    private var isLoading = false
    var didUpdate: (() -> Void)?
    var didFail: ((Error) -> Void)?
    private var conversionRates: [String: Double] = [:] {
        didSet {
            didUpdate?()
        }
    }
    
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    func getStandard(code: String) {
        if isLoading {
            return
        }
        isLoading = true
        apiManager.getStandard(code: code) { [weak self] result in
            switch result {
            case .success(let response):
                self?.conversionRates = response.conversionRates
            case .failure(let error):
                self?.didFail?(error)
            }
            self?.isLoading = false
        }
    }
    
    var getCount: Int {
        return conversionRates.count
    }
    
    func getCellViewModel(at index: Int) -> StandardCellViewModel {
        let code = Array(conversionRates.keys).sorted()[index]
        let rate = conversionRates[code] ?? 0
        return StandardCellViewModel(code: code, rate: rate)
    }
}
