//
//  CodeListViewModel.swift
//  ExchangeRate
//
//  Created by Teerawat Vanasapdamrong on 14/2/2565 BE.
//

import Foundation

class CodeListViewModel {
    private var apiManager: APIManagerProtocol
    private var isLoading = false
    var didUpdate: (() -> Void)?
    var didFail: ((Error) -> Void)?
    private var supportedCodes: [[String]] = [] {
        didSet {
            didUpdate?()
        }
    }
    
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    func search(keyword: String?) {
        supportedCodes = DataInstance.shared.searchSupportedCodes(keyword: keyword)
    }
    
    var cellCount: Int {
        return supportedCodes.count
    }
    
    func getCellViewModel(at index: Int) -> CodeCellViewModel {
        return CodeCellViewModel(code: supportedCodes[index])
    }
    
    func getCodeForIndex(_ index: Int) -> [String] {
        return supportedCodes[index]
    }
}
