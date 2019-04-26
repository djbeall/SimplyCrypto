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
    @IBOutlet weak var lineChartView: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.lineChartView.drawGridBackgroundEnabled = true
        self.lineChartView.autoScaleMinMaxEnabled = true
        self.lineChartView.legend.enabled = false
        let xAxis = self.lineChartView.xAxis
        xAxis.drawLabelsEnabled = false
        setChart(20)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    func setChart(_ count: Int = 10) {
        var values: [ChartDataEntry] = []
        for i in 1...count {
            values.append(ChartDataEntry(x: Double(i), y: Double(i * i)))
        }
        let set1 = LineChartDataSet(entries: values, label: "")
        let data = LineChartData(dataSet: set1)
        
        
        self.lineChartView.data = data
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
