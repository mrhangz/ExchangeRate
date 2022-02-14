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
    weak var delegate: CodeListViewControllerDelegate?
    var viewModel: CodeListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField?.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        viewModel = CodeListViewModel()
        
        viewModel.didUpdate = { [weak self] in
            self?.tableView?.reloadData()
        }
        viewModel.search(keyword: nil)
    }
    
    @objc func textDidChange() {
        viewModel.search(keyword: searchTextField?.text)
    }
}

extension CodeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CodeCell", for: indexPath) as? CodeTableViewCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModel.getCellViewModel(at: indexPath.row)
        cell.displayCell(viewModel: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let code = viewModel.getCodeForIndex(indexPath.row)
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
