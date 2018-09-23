//
//  AnalyticsVC.swift
//  Clerkie-challenge
//
//  Created by Antonio Chan on 2018/9/22.
//  Copyright © 2018 Antonio Chan. All rights reserved.
//

import UIKit
import Charts
import Darwin

class AnalyticsVC: UIViewController {
    
    var monthArray = ["January", "Febuary", "March", "April", "May", "June", "July", "August", "September", "November", "December"]
    
    var colorsBase = [UIColor.FlatColor.Blue.PastelBlue, UIColor.FlatColor.Orange.PastelOrange, UIColor.FlatColor.Red.PastelRed, UIColor.FlatColor.Purple.PastelPurple]

    
    var titleLabel = ["Entertainment", "Food", "Rent", "Income"]
    var numberAmount = [654, 231, 900, 1150]
    
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    @IBOutlet weak var singleFilledLineChart: LineChartView!
    
    @IBOutlet weak var baseCollectionView: UICollectionView!
    
    private class CubicLineSampleFillFormatter: IFillFormatter {
        func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
            return -10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Pie chart data
        randomPieChart()
        
        //Single line chart
        setLineChartValues()
        setupSingleLineChart()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Analytics"
    }
    
    func randomPieChart() {
        let entertainment = PieChartDataEntry(value: Double(Int(arc4random_uniform(6) + 1)))
        let housing = PieChartDataEntry(value: Double(Int(arc4random_uniform(6) + 1)))
        let food = PieChartDataEntry(value: Double(Int(arc4random_uniform(6) + 1)))
        numberOfDownloadsDataEntries = [entertainment, housing, food]
    }
    
    
    func setLineChartValues(_ count : Int = 20) {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(UInt32(count)) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: values, label: "")
        
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 2.5
        set1.circleRadius = 4
        set1.setCircleColor(.white)
        set1.highlightColor = UIColor.FlatColor.Blue.PastelBlue
        set1.fillColor = UIColor.FlatColor.Blue.PastelBlue
        set1.fillAlpha = 1
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.fillFormatter = CubicLineSampleFillFormatter()
        
        let data = LineChartData(dataSet: set1)
        set1.colors = [UIColor.FlatColor.Blue.PastelBlue]
        data.setDrawValues(true)
        
        self.singleFilledLineChart.data = data
        
    }
    
    func setupSingleLineChart() {
        
        singleFilledLineChart.dragEnabled = false
        singleFilledLineChart.setScaleEnabled(false)
        singleFilledLineChart.pinchZoomEnabled = false
        singleFilledLineChart.maxHighlightDistance = 300
        
        singleFilledLineChart.xAxis.enabled = false
        singleFilledLineChart.xAxis.drawAxisLineEnabled = true
        
        let yAxis = singleFilledLineChart.leftAxis
        yAxis.labelTextColor = .white
        yAxis.labelPosition = .insideChart
        yAxis.axisLineColor = .black
        yAxis.drawAxisLineEnabled = true
        yAxis.drawGridLinesEnabled = false
        
        singleFilledLineChart.rightAxis.enabled = false
        singleFilledLineChart.leftAxis.enabled = false
        singleFilledLineChart.legend.enabled = false
        singleFilledLineChart.chartDescription?.text = ""
    }
    
}

extension AnalyticsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.baseCollectionView {
            return titleLabel.count
        } else {
           return monthArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.baseCollectionView {
            
            let cell: BaseInfoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BaseInfoCollectionViewCell", for: indexPath) as! BaseInfoCollectionViewCell
            
            cell.titleLabel.text = titleLabel[indexPath.row]
            
            let duration: Double = 2.0 //seconds
            DispatchQueue.global().async {
                for i in 0 ..< (self.numberAmount[indexPath.row] + 1) {
                    let sleepTime = UInt32(duration/Double(self.numberAmount[indexPath.row]) * 1000000.0)
                    usleep(sleepTime)
                    DispatchQueue.main.async {
                        cell.amountLabel.text = "$\(i)"
                    }
                }
            }
            cell.baseCellView.backgroundColor = colorsBase[indexPath.row]
            
            
            return cell
        } else {
            let cell: PieChartCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PieChartCollectionViewCell", for: indexPath) as! PieChartCollectionViewCell
            
            
            let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
            let chartData = PieChartData(dataSet: chartDataSet)
            
            let colors = [UIColor.FlatColor.Blue.PastelBlue, UIColor.FlatColor.Orange.PastelOrange, UIColor.FlatColor.Red.PastelRed]
            chartDataSet.colors = colors
            
            self.randomPieChart()
            cell.PieChartView.data = chartData
            cell.PieChartView.chartDescription?.text = monthArray[indexPath.row]
            cell.PieChartView.legend.enabled = false
            cell.PieChartView.holeRadiusPercent = 0.5
            
            return cell
        }
        
        
    }
    
}
