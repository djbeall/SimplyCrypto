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
import Firebase

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
    var coinToSegueFull: String? = nil
    var ref = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser?.uid ?? ""
    var lst = [""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        // Do any additional setup after loading the view.
        navigationBar.title = "SimplyCrypto"
        print("wynh 1")
        
        
        CryptoContainer.getCoinList(completionHandler: { dic, error in
            print("wynh 2")
            
                print("wynh 3")
            DispatchQueue.main.async {
                self.completeCoinDict = dic
            
            self.dismiss(animated: false, completion: nil)
            }
         
        })
        
        print("wynh 4")
        tableView.delegate = self
        tableView.dataSource = self
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            var value: NSDictionary
            if let _ = snapshot.value as? NSNull {
                value = NSDictionary()
            } else {
                value = snapshot.value as! NSDictionary
            }
            self.lst = value.allKeys as! [String]
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lst.count
            //UserDefaults.standard.array(forKey: "MyCoins")?.count ?? 0
    }
    
    @IBAction func logOut(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        self.performSegue(withIdentifier: "Not Signed In", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath)
        //let str = UserDefaults.standard.array(forKey: "MyCoins")?[indexPath.row] as? String?
        if let myCell = cell as? CryptoCell, let str = lst[indexPath.row] as String? {
            myCell.coinName.text = str
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currCell = tableView.cellForRow(at: indexPath) as? CryptoCell {
            print(completeCoinDict)
            print(currCell)
            print(currCell.coinName)
            coinToSegueFull = currCell.coinName.text
            coinToSegue = completeCoinDict![currCell.coinName!.text! as String]
            print(currCell.coinName!.text! as String)
            print(coinToSegue)
        }
        self.performSegue(withIdentifier: "MoreInfo", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CoinList" {
            let seg = segue.destination as? CoinListViewController
        
            seg?.coinList = self.completeCoinDict?.keys.sorted()
        } else {
            let seg = segue.destination as? MoreInfoViewController
            print(coinToSegue)
            seg?.coin = coinToSegue
            seg?.coinFull = coinToSegueFull
        }
    }
}

