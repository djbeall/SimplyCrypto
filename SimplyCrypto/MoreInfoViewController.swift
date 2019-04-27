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
    var container: CryptoContainer?
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var timeButtons: UISegmentedControl!
    @IBAction func timeChange(_ sender: UISegmentedControl) {
        setChart()
    }
    @IBOutlet weak var crypto: UILabel!
    @IBOutlet weak var world: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        container = CryptoContainer()
        let test = container?.getCurrentPrice(crypto: cryptoCurrencies.BTC.rawValue, world: worldCurrencies.USD.rawValue)
        if let worldText = test?.worldValue, let cryptoText = test?.crptoValue {
            world.text = String(worldText)
            crypto.text = String(cryptoText)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.lineChartView.drawGridBackgroundEnabled = true
        self.lineChartView.autoScaleMinMaxEnabled = true
        self.lineChartView.legend.enabled = false
        let xAxis = self.lineChartView.xAxis
        xAxis.drawLabelsEnabled = false
        setChart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    func setChart() {
        var values: [ChartDataEntry] = []
        let count: Int
        switch timeButtons.selectedSegmentIndex {
        case 0:
            count = 24
        case 1:
            count = 7
        case 2:
            count = 15
        case 3:
            count = 12
        default:
            count = 1
            break
        }
        for i in 1...count {
            values.append(ChartDataEntry(x: Double(i), y: Double(i * i)))
        }
        let set1 = LineChartDataSet(entries: values, label: "")
        let data = LineChartData(dataSet: set1)
        
        
        self.lineChartView.data = data
        self.lineChartView.animate(xAxisDuration: 1, yAxisDuration: 1)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
