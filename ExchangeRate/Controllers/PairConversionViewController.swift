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
    
    private var viewModel: PairConversionViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PairConversionViewModel()
        viewModel.rateDidUpdate = { [weak self] in
            self?.viewModel.calculateTarget(baseString: self?.baseTextField?.text)
        }
        viewModel.baseDidUpdate = { [weak self] string in
            self?.baseTextField?.text = string
        }
        viewModel.targetDidUpdate = { [weak self] string in
            self?.targetTextField?.text = string
        }
        viewModel.didFail = { [weak self] error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .destructive)
            alert.addAction(action)
            self?.present(alert, animated: true, completion: nil)
        }
        
        baseTextField?.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        targetTextField?.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        baseTextField?.addTarget(self, action: #selector(textDidEndEditing(sender:)), for: .editingDidEnd)
        targetTextField?.addTarget(self, action: #selector(textDidEndEditing(sender:)), for: .editingDidEnd)
        baseTextField?.addTarget(self, action: #selector(textDidBeginEditing(sender:)), for: .editingDidBegin)
        targetTextField?.addTarget(self, action: #selector(textDidBeginEditing(sender:)), for: .editingDidBegin)
        Utilities.addKeyboardDoneButton(sender: self, textField: baseTextField)
        Utilities.addKeyboardDoneButton(sender: self, textField: targetTextField)
        
        let _ = DataInstance.shared // get supported codes, must be improved
        
        viewModel?.getPairConversion()
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == baseTextField {
            viewModel.calculateTarget(baseString: baseTextField?.text)
        } else if sender == targetTextField {
            viewModel.calculateBase(targetString: targetTextField?.text)
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
    
    @IBAction func codeButtonTapped(sender: UIButton) {
        guard let codeListVC = storyboard?.instantiateViewController(withIdentifier: "CodeListVC") as? CodeListViewController else {
            return
        }
        
        if sender == baseButton {
            viewModel.selectingCode = .base
        } else {
            viewModel.selectingCode = .target
        }
        
        codeListVC.delegate = self
        navigationController?.pushViewController(codeListVC, animated: true)
    }
    
    @IBAction func swapTapped(sender: UIButton) {
        baseTextField?.text = targetTextField?.text
        viewModel.swap(targetString: targetTextField?.text)
        updateButtonText()
    }
    
    func updateButtonText() {
        baseButton?.setTitle(viewModel.baseText(), for: .normal)
        targetButton?.setTitle(viewModel.targetText(), for: .normal)
    }
}

extension PairConversionViewController: CodeListViewControllerDelegate {
    func codeDidSelect(code: [String]) {
        viewModel.updateCode(code: code[0])
        updateButtonText()
        viewModel.getPairConversion()
    }
}
