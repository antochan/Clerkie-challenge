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
    var iconImages = [#imageLiteral(resourceName: "Entertainment"), #imageLiteral(resourceName: "Food"), #imageLiteral(resourceName: "Rent"), #imageLiteral(resourceName: "income")]
    
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    @IBOutlet weak var singleFilledLineChart: LineChartView!
    
    @IBOutlet weak var doubleLineChart: LineChartView!
    
    @IBOutlet weak var horizontalBarChart: HorizontalBarChartView!
    
    @IBOutlet weak var baseCollectionView: UICollectionView!
    
    @IBOutlet weak var barChart: BarChartView!
    
    
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
        
        //Bar
        setBarChartDataCount(8, range: 100)
        setupHorizontalBarChart()
        
        //Duo Line
        setDataCountDuoLine(12, range: 100)
        setupDuoLineChart()
        
        //Bar chart
        setUpVerticalBarChart()
        setVerticalBarDataCount(12, range: 100)
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
        singleFilledLineChart.animate(yAxisDuration: 2.0)
    }
    
    
    func setupDuoLineChart() {
        doubleLineChart.chartDescription?.enabled = false
        doubleLineChart.dragEnabled = true
        doubleLineChart.setScaleEnabled(true)
        doubleLineChart.pinchZoomEnabled = true
        
        let l = doubleLineChart.legend
        l.form = .line
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.textColor = .black
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let xAxis = doubleLineChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .black
        xAxis.drawAxisLineEnabled = false
        
        let leftAxis = doubleLineChart.leftAxis
        leftAxis.labelTextColor = .black
        leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        let rightAxis = doubleLineChart.rightAxis
        rightAxis.labelTextColor = .black
        rightAxis.axisMaximum = 1100
        rightAxis.axisMinimum = 0
        rightAxis.granularityEnabled = false
        
        doubleLineChart.animate(yAxisDuration: 2.5)
    }
    
    func setDataCountDuoLine(_ count: Int, range: UInt32) {
        let yVals1 = (0..<count).map { (i) -> ChartDataEntry in
            let mult = range / 2
            let val = Double(arc4random_uniform(mult) + 50)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let yVals2 = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 450)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: yVals1, label: "Your Spending")
        set1.mode = .cubicBezier
        set1.axisDependency = .left
        set1.setColor(UIColor.FlatColor.Blue.PastelBlue)
        set1.setCircleColor(UIColor.FlatColor.Blue.PastelBlue)
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.fillAlpha = 65/255
        set1.fillColor = UIColor.FlatColor.Blue.PastelBlue
        set1.highlightColor = UIColor.FlatColor.Blue.PastelBlue
        set1.drawCircleHoleEnabled = false
        set1.valueTextColor = UIColor.FlatColor.Blue.PastelBlue
        
        let set2 = LineChartDataSet(values: yVals2, label: "Nation Average")
        set2.mode = .cubicBezier
        set2.axisDependency = .right
        set2.setColor(UIColor.FlatColor.Red.PastelRed)
        set2.setCircleColor(UIColor.FlatColor.Red.PastelRed)
        set2.lineWidth = 2
        set2.circleRadius = 3
        set2.fillAlpha = 65/255
        set2.fillColor = UIColor.FlatColor.Red.PastelRed
        set2.highlightColor = UIColor.FlatColor.Red.PastelRed
        set2.drawCircleHoleEnabled = false
        set2.valueTextColor = UIColor.FlatColor.Red.PastelRed
        
        let data = LineChartData(dataSets: [set1, set2])
        data.setValueFont(.systemFont(ofSize: 9))
        
        doubleLineChart.data = data
    }
    func setupHorizontalBarChart() {
        let xAxis = horizontalBarChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = false
        xAxis.granularity = 10
        
        let leftAxis = horizontalBarChart.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0
        
        let rightAxis = horizontalBarChart.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0
        
        let l = horizontalBarChart.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4

        
        horizontalBarChart.fitBars = true
        horizontalBarChart.chartDescription?.text = ""
        horizontalBarChart.animate(yAxisDuration: 2.5)
    }
    
    func setBarChartDataCount(_ count: Int, range: UInt32) {
        let barWidth = 9.0
        let spaceForBar = 10.0
        
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))
            return BarChartDataEntry(x: Double(i)*spaceForBar, y: val, icon: #imageLiteral(resourceName: "analytics"))
        }
        
        let set1 = BarChartDataSet(values: yVals, label: "DataSet")
        set1.drawIconsEnabled = false
        set1.highlightColor = UIColor.FlatColor.Blue.PastelBlue
        set1.setColor(UIColor.FlatColor.Blue.PastelBlue, alpha: 1.0)
        
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:10)!)
        data.barWidth = barWidth
        
        horizontalBarChart.data = data
    }
    
    
    func setUpVerticalBarChart() {
        barChart.chartDescription?.enabled = false
        barChart.maxVisibleCount = 60
        barChart.pinchZoomEnabled = false
        barChart.drawBarShadowEnabled = false
        
        let xAxis = barChart.xAxis
        xAxis.labelPosition = .bottom
        
        barChart.legend.enabled = false
    }
    
    func setVerticalBarDataCount(_ count: Int, range: Double) {
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(UInt32(mult))) + mult/3
            return BarChartDataEntry(x: Double(i), y: val)
        }
        
        var set1: BarChartDataSet! = nil
        if let set = barChart.data?.dataSets.first as? BarChartDataSet {
            set1 = set
            set1?.values = yVals
            barChart.data?.notifyDataChanged()
            barChart.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(values: yVals, label: "Data Set")
            set1.colors = colorsBase
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            barChart.data = data
            barChart.fitBars = true
        }
        
        barChart.setNeedsDisplay()
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
            cell.iconImage.image = iconImages[indexPath.row]
            
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
            cell.PieChartView.chartDescription?.font = UIFont.avenirBookFontOfSize(size: 10)
            cell.PieChartView.legend.enabled = false
            cell.PieChartView.holeRadiusPercent = 0.5
            cell.PieChartView.animate(xAxisDuration: 1.0, easingOption: .easeOutBack)
            
            return cell
        }
        
        
    }
    
}
