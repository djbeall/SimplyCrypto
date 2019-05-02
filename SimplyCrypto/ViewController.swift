//
//  ViewController.swift
//  SimplyCrypto
//
//  Created by Daniel Beall on 4/23/19.
//  Copyright © 2019 Group18. All rights reserved.
//

import UIKit
import Charts
import FirebaseAuth

class CryptoCell: UITableViewCell {
    @IBOutlet weak var coinName: UILabel!
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "CoinList", sender: self)
        
    }
    var completeCoinDict: [String: String]? = nil
    var coinToSegue: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationBar.title = "SimplyCrypto"
        CryptoContainer.getCoinList(completionHandler: { dic, error in
            DispatchQueue.main.async {
                self.completeCoinDict = dic
            }            
        })
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaults.standard.array(forKey: "MyCoins")?.count ?? 0
    }
    
    @IBAction func logOut(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        self.performSegue(withIdentifier: "Not Signed In", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath)
        if let myCell = cell as? CryptoCell, let str = UserDefaults.standard.array(forKey: "MyCoins")?[indexPath.row] as? String? {
            myCell.coinName.text = str
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currCell = tableView.cellForRow(at: indexPath) as? CryptoCell {
            print(completeCoinDict![currCell.coinName!.text! as String] as! String)
            coinToSegue = completeCoinDict![currCell.coinName!.text! as String]
        }
        self.performSegue(withIdentifier: "MoreInfo", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        if segue.identifier == "CoinList" {
            let seg = segue.destination as? CoinListViewController
        
            seg?.coinList = self.completeCoinDict?.keys.sorted()
        } else {
            let seg = segue.destination as? MoreInfoViewController
            print(coinToSegue)
            seg?.coin = coinToSegue
        
        }
    }
}

