//
//  CoinListViewController.swift
//  SimplyCrypto
//
//  Created by Daniel Beall on 4/28/19.
//  Copyright © 2019 Group18. All rights reserved.
//

import UIKit

class CoinCell: UITableViewCell {
    
    @IBOutlet weak var coinName: UILabel!
}

class CoinListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var isSearching = false
    var coinList: [String]? = ["hi"]
    var filteredData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        }
        
        return coinList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath)
        if let myCell = cell as? CoinCell {
            if isSearching {
                myCell.coinName.text = filteredData[indexPath.row]
            } else {
                if let lst = coinList{
                    myCell.coinName.text = lst[indexPath.row]
                }
            }
           
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var lst = UserDefaults.standard.array(forKey: "MyCoins") as? [String] ?? [] as [String]
        if let currCell = tableView.cellForRow(at: indexPath) as? CoinCell {
            let newStr = currCell.coinName!.text! as String
            if !lst.contains(newStr) {
                lst.append(newStr)
                UserDefaults.standard.set(lst, forKey: "MyCoins")
                navigationController?.popViewController(animated: true)
            }
        }
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
        } else {
            isSearching = true
            filteredData = (coinList?.filter { $0.lowercased().contains(searchText.lowercased())})!
            
            tableView.reloadData()
        }
    }
}
