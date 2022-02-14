//
//  StandardListViewController.swift
//  ExchangeRate
//
//  Created by Teerawat Vanasapdamrong on 9/2/2565 BE.
//

import UIKit

class StandardListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private var codeButton: UIButton?
    var viewModel: StandardListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = StandardListViewModel()
        viewModel.didUpdate = { [weak self] in
          self?.tableView?.reloadData()
        }
        viewModel.didFail = { [weak self] error in
          let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
          let action = UIAlertAction(title: "OK", style: .destructive)
          alert.addAction(action)
          self?.present(alert, animated: true, completion: nil)
        }
        
        viewModel.getStandard(code: "THB")
    }
    
    @IBAction func codeTapped(sender: UIButton) {
        guard let codeListVC = storyboard?.instantiateViewController(withIdentifier: "CodeListVC") as? CodeListViewController else {
            return
        }
        
        codeListVC.delegate = self
        navigationController?.pushViewController(codeListVC, animated: true)
    }
}

extension StandardListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath) as? StandardTableViewCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModel.getCellViewModel(at: indexPath.row)
        cell.displayCell(viewModel: cellViewModel)
        
        return cell
    }
}

extension StandardListViewController: CodeListViewControllerDelegate {
    func codeDidSelect(code: [String]) {
        codeButton?.setTitle("\(code[0]), \(code[1])", for: .normal)
        viewModel.getStandard(code: code[0])
    }
}
