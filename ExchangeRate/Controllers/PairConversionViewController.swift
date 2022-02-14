//
//  PairConversionViewController.swift
//  ExchangeRate
//
//  Created by Teerawat Vanasapdamrong on 13/2/2565 BE.
//

import UIKit

class PairConversionViewController: UIViewController {
    @IBOutlet private var baseButton: UIButton?
    @IBOutlet private var targetButton: UIButton?
    @IBOutlet private var swapButton: UIButton?
    @IBOutlet private var baseTextField: UITextField?
    @IBOutlet private var targetTextField: UITextField?
    private var baseCode: String = "THB"
    private var targetCode: String = "SGD"
    private var rate: Double = 1
    private var selectingButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseTextField?.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        targetTextField?.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        baseTextField?.addTarget(self, action: #selector(textDidEndEditing(sender:)), for: .editingDidEnd)
        targetTextField?.addTarget(self, action: #selector(textDidEndEditing(sender:)), for: .editingDidEnd)
        baseTextField?.addTarget(self, action: #selector(textDidBeginEditing(sender:)), for: .editingDidBegin)
        targetTextField?.addTarget(self, action: #selector(textDidBeginEditing(sender:)), for: .editingDidBegin)
        Utilities.addKeyboardDoneButton(sender: self, textField: baseTextField)
        Utilities.addKeyboardDoneButton(sender: self, textField: targetTextField)
        
        getPairConversion()
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == baseTextField {
            calculateTarget()
        } else if sender == targetTextField {
            calculateBase()
        }
    }
    
    @objc func textDidBeginEditing(sender: UITextField) {
        sender.selectAll(nil)
    }
    
    @objc func textDidEndEditing(sender: UITextField) {
        guard let targetString = targetTextField?.text, let targetAmount = Double(targetString), let baseString = baseTextField?.text, let baseAmount = Double(baseString) else {
            return
        }
        baseTextField?.text = String(format: "%.2f", baseAmount)
        targetTextField?.text = String(format: "%.2f", targetAmount)
    }
    
    func getPairConversion() {
        APIManager().getPairConversion(baseCode: baseCode, targetCode: targetCode) { [weak self] result in
            switch result {
            case .success(let response):
                self?.rate = response.conversionRate
                self?.calculateTarget()
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .destructive)
                alert.addAction(okAction)
                self?.navigationController?.present(alert, animated: true)
            }
        }
    }
    
    func calculateBase() {
        guard let targetString = targetTextField?.text, let targetAmount = Double(targetString) else {
            return
        }
        let baseAmount = targetAmount / rate
        baseTextField?.text = String(format: "%.2f", baseAmount)
    }
    
    func calculateTarget() {
        guard let baseString = baseTextField?.text, let baseAmount = Double(baseString) else {
            return
        }
        let targetAmount = baseAmount * rate
        targetTextField?.text = String(format: "%.2f", targetAmount)
    }
    
    @IBAction func codeButtonTapped(sender: UIButton) {
        guard let codeListVC = storyboard?.instantiateViewController(withIdentifier: "CodeListVC") as? CodeListViewController else {
            return
        }
        
        selectingButton = sender
        codeListVC.delegate = self
        navigationController?.pushViewController(codeListVC, animated: true)
    }
    
    @IBAction func swapTapped(sender: UIButton) {
        let temp = targetCode
        targetCode = baseCode
        baseCode = temp
        rate = 1 / rate
        baseTextField?.text = targetTextField?.text
        baseButton?.setTitle(baseText(), for: .normal)
        targetButton?.setTitle(targetText(), for: .normal)
        calculateTarget()
    }
    
    func baseText() -> String {
        return "\(baseCode), \(DataInstance.shared.getDescriptionFor(code: baseCode))"
    }
    
    func targetText() -> String {
        return "\(targetCode), \(DataInstance.shared.getDescriptionFor(code: targetCode))"
    }
}

extension PairConversionViewController: CodeListViewControllerDelegate {
    func codeDidSelect(code: [String]) {
        selectingButton?.setTitle("\(code[0]), \(code[1])", for: .normal)
        if selectingButton == baseButton {
            baseCode = code[0]
        } else if selectingButton == targetButton {
            targetCode = code[0]
        }
        getPairConversion()
    }
}
