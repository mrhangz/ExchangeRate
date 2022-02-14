//
//  DataInstance.swift
//  ExchangeRate
//
//  Created by Teerawat Vanasapdamrong on 9/2/2565 BE.
//

import Foundation

class DataInstance {
    static let shared = DataInstance()
    var defaultCode: String?
    var supportedCodes: [[String]]?
    
    private init() {
        
    }
    
    func searchSupportedCodes(keyword: String) -> [[String]] {
        return supportedCodes?.filter({ code in
            code[0].lowercased().contains(keyword.lowercased()) || code[1].lowercased().contains(keyword.lowercased())
        }) ?? []
    }
    
    func getDescriptionFor(code: String) -> String {
        guard let result = supportedCodes?.first(where: { $0[0] == code }) else {
            return ""
        }
        return result[1]
    }
}
