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
    private var conversionRates: [String: Double]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStandard(code: "THB")
    }
    
    func getStandard(code: String) {
        APIManager().getStandard(code: code) { [weak self] result in
            switch result {
            case .success(let response):
                self?.conversionRates = response.conversionRates
                self?.tableView?.reloadData()
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .destructive)
                alert.addAction(okAction)
                self?.navigationController?.present(alert, animated: true)
            }
        }
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
        return conversionRates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath) as? StandardTableViewCell, let rates = conversionRates else {
            return UITableViewCell()
        }
        
        let code = Array(rates.keys).sorted()[indexPath.row]
        let rate = rates[code] ?? 0
        let cellViewModel = StandardCellViewModel(code: code, rate: rate)
        cell.displayCell(viewModel: cellViewModel)
        
        return cell
    }
}

extension StandardListViewController: CodeListViewControllerDelegate {
    func codeDidSelect(code: [String]) {
        codeButton?.setTitle("\(code[0]), \(code[1])", for: .normal)
        getStandard(code: code[0])
    }
}
