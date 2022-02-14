//
//  CodeListViewController.swift
//  ExchangeRate
//
//  Created by Teerawat Vanasapdamrong on 8/2/2565 BE.
//

import UIKit

protocol CodeListViewControllerDelegate: AnyObject {
    func codeDidSelect(code: [String])
}

class CodeListViewController: UIViewController {
    @IBOutlet private var searchTextField: UITextField?
    @IBOutlet private var tableView: UITableView?
    private var supportedCodes: [[String]]?
    weak var delegate: CodeListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField?.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        if supportedCodes == nil {
            APIManager().getSupportedCodes { [weak self] result in
                switch result {
                case .success(let response):
                    print(response)
                    DataInstance.shared.supportedCodes = response.supportedCodes
                    self?.supportedCodes = response.supportedCodes
                    self?.tableView?.reloadData()
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .destructive)
                    alert.addAction(okAction)
                    self?.navigationController?.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc func textDidChange() {
        if let searchText = searchTextField?.text {
            supportedCodes = DataInstance.shared.searchSupportedCodes(keyword: searchText)
        } else {
            supportedCodes = DataInstance.shared.supportedCodes
        }
        
        tableView?.reloadData()
    }
}

extension CodeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supportedCodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CodeCell", for: indexPath) as? CodeTableViewCell, let code = supportedCodes?[indexPath.row] else {
            return UITableViewCell()
        }
        
        let cellViewModel = CodeCellViewModel(code: code)
        cell.displayCell(viewModel: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let code = supportedCodes?[indexPath.row] else {
            return
        }
        
        delegate?.codeDidSelect(code: code)
        navigationController?.popViewController(animated: true)
    }
}

extension CodeListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
