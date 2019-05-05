//
//  MoreInfoViewController.swift
//  SimplyCrypto
//
//  Created by Daniel Beall on 4/26/19.
//  Copyright © 2019 Group18. All rights reserved.
//

import UIKit
import Charts

class MoreInfoViewController: UIViewController {

    var coin: String?
    var coinFull: String?
    var currentPrice: Double? = nil {
        willSet {
            self.crypto.text = String(newValue!)
            setGains(currPrice: newValue!)
        }
    }
    @IBOutlet weak var gainsOutlet: UILabel!
    @IBOutlet weak var gainsLabel: UILabel!
    var amountOwned: Double? = nil
    var valueBought: Double? = nil
    var container: CryptoContainer?
    @IBOutlet weak var trackButton: UIButton!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var timeButtons: UISegmentedControl!
    @IBAction func timeChange(_ sender: UISegmentedControl) {
        setChart()
    }
    @IBOutlet weak var crypto: UILabel!
    @IBOutlet weak var world: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        CryptoContainer.getCurrentPrice(crypto: coin!, world: worldCurrencies.USD.rawValue) { str, error in
            DispatchQueue.main.async {
                print(str)
                
                self.currentPrice = str
            }
            
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.lineChartView.drawGridBackgroundEnabled = true
        self.lineChartView.autoScaleMinMaxEnabled = true
        self.lineChartView.legend.enabled = false
        let xAxis = self.lineChartView.xAxis
        xAxis.drawLabelsEnabled = false
        setChart()
        trackButton.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGains(currPrice: currentPrice)
        
    }
    
    func setGains(currPrice: Double?) {
        amountOwned = UserDefaults.standard.dictionary(forKey: "Amount")?[coin!] as! Double?
        valueBought = UserDefaults.standard.dictionary(forKey: "Value")?[coin!] as! Double?
        if let _ = self.valueBought, let _ = self.amountOwned, let curr = currPrice {
            gainsLabel.text = "Gains/Losses: "
            let val = self.computeGains(curr: curr)
            gainsOutlet.text = String(val)
            if val >= 0 {
                gainsOutlet.textColor = UIColor.green
            } else {
                gainsOutlet.textColor = UIColor.red
            }
        }
    }
    
    func computeGains(curr: Double?) -> Double {
        return curr! * amountOwned! - valueBought! * amountOwned!
    }
    
    func setChart() {
        let count: Int
        switch timeButtons.selectedSegmentIndex {
        case 0:
            count = 23
            CryptoContainer.getHistoricalPrice(crypto: coin!, world: worldCurrencies.USD.rawValue, timeType: timeType.histoday.rawValue, limit: count, timeAggregate: 1) { res, error in
                DispatchQueue.main.async {
                    self.populateChart(ohclvArr: res)
                }
            }
        case 1:
            count = 6
            CryptoContainer.getHistoricalPrice(crypto: coin!, world: worldCurrencies.USD.rawValue, timeType: timeType.histoday.rawValue, limit: count, timeAggregate: 1) { res, error in
                DispatchQueue.main.async {
                    self.populateChart(ohclvArr: res)
                }
            }
        case 2:
            count = 29
            CryptoContainer.getHistoricalPrice(crypto: coin!, world: worldCurrencies.USD.rawValue, timeType: timeType.histoday.rawValue, limit: count, timeAggregate: 1) { res, error in
                DispatchQueue.main.async {
                    self.populateChart(ohclvArr: res)
                }
            }
        case 3:
            count = 11
            CryptoContainer.getHistoricalPrice(crypto: coin!, world: worldCurrencies.USD.rawValue, timeType: timeType.histoday.rawValue, limit: count, timeAggregate: 30) { res, error in
                DispatchQueue.main.async {
                    self.populateChart(ohclvArr: res)
                }
            }
        default:
            count = 23
            CryptoContainer.getHistoricalPrice(crypto: coin!, world: worldCurrencies.USD.rawValue, timeType: timeType.histoday.rawValue, limit: count, timeAggregate: 1) { res, error in
                DispatchQueue.main.async {
                    self.populateChart(ohclvArr: res)
                }
            }
        }
        
    }
    /* Using a seperate function due to the nature of the aysnchrounous api call*/
    func populateChart(ohclvArr:[CryptoContainer.Ohlcv]) {
        var values: [ChartDataEntry] = []
        for i in 1...ohclvArr.count {
            values.append(ChartDataEntry(x: Double(i), y: ohclvArr[i-1].high ?? -1))
        }
        let date = NSDate(timeIntervalSinceReferenceDate: ohclvArr[0].time!).description
        let set1 = LineChartDataSet(entries: values, label: date)
        let data = LineChartData(dataSet: set1)
        
        
        self.lineChartView.data = data
        self.lineChartView.animate(xAxisDuration: 1, yAxisDuration: 1)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let seg = segue.destination as? TrackCurrencyViewController
        seg?.currentCurrency = coin
        seg?.currentCurrencyFull = coinFull
    }

}
