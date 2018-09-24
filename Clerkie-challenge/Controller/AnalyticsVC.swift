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
    
    var colorsBase = [UIColor.FlatColor.Red.HotPink,UIColor.FlatColor.Blue.NavyBlue, UIColor.FlatColor.Red.HotPink, UIColor.FlatColor.Blue.NavyBlue]
    var twoColors = [UIColor.FlatColor.Red.HotPink, UIColor.FlatColor.Blue.AquaBlue]

    var titleLabel = ["Entertainment", "Food", "Rent", "Income"]
    var numberAmount = [654, 231, 900, 1150]
    var iconImages = [#imageLiteral(resourceName: "Entertainment"), #imageLiteral(resourceName: "Food"), #imageLiteral(resourceName: "Rent"), #imageLiteral(resourceName: "income")]
    
    @IBOutlet weak var pieChartBackground: UIView!
    @IBOutlet weak var lineChartBackground: UIView!
    @IBOutlet weak var duoLineChartBackground: UIView!
    @IBOutlet weak var horizontalBarBackground: UIView!
    @IBOutlet weak var barBackground: UIView!
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    @IBOutlet weak var singleFilledLineChart: LineChartView!
    
    @IBOutlet weak var PieChartView: PieChartView!
    
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
        setPieChart()
        
        //Single line chart
        setLineChartValues()
        setupSingleLineChart()
        
        //Bar
        //setBarChartDataCount(count: 8, range: 100)
        setupHorizontalBarChart()
        
        //Duo Line
        setDataCountDuoLine(12, range: 100)
        setupDuoLineChart()
        
        //Bar chart
        setUpVerticalBarChart()
        setVerticalBarDataCount(12, range: 100)
        
        //drop shadows
        setupBackgrounds()
    }
    
    func setupBackgrounds() {
        pieChartBackground.dropShadow()
        lineChartBackground.dropShadow()
        duoLineChartBackground.dropShadow()
        horizontalBarBackground.dropShadow()
        barBackground.dropShadow()
    }
    
    func randomPieChart() {
        let entertainment = PieChartDataEntry(value: Double(Int(arc4random_uniform(20) + 1)), label: "Entertainment")
        let housing = PieChartDataEntry(value: Double(Int(arc4random_uniform(20) + 1)), label: "Housing")
        let food = PieChartDataEntry(value: Double(Int(arc4random_uniform(20) + 1)), label: "Food")
        numberOfDownloadsDataEntries = [entertainment, housing, food]
    }
    
    func setPieChart() {
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        chartDataSet.drawValuesEnabled = false
    
        let colors = [UIColor.FlatColor.Blue.PastelBlue, UIColor.FlatColor.Orange.PastelOrange, UIColor.FlatColor.Red.PastelRed]
        chartDataSet.colors = colors
    
        self.randomPieChart()
        PieChartView.data = chartData
        PieChartView.chartDescription?.text = ""
        PieChartView.chartDescription?.font = UIFont.avenirBookFontOfSize(size: 10)
        PieChartView.legend.enabled = true
        PieChartView.legend.textColor = .white
        PieChartView.holeRadiusPercent = 0
        PieChartView.animate(xAxisDuration: 1.0, easingOption: .easeOutBack)
    }
    
    
    func setLineChartValues(_ count : Int = 8) {
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
        set1.highlightColor = UIColor.FlatColor.Red.HotPink
        set1.fill = Fill.fillWithColor(UIColor.FlatColor.Red.HotPink.withAlphaComponent(0.6))
        set1.drawFilledEnabled = true
        set1.fillAlpha = 1
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.fillFormatter = CubicLineSampleFillFormatter()
        
        let data = LineChartData(dataSet: set1)
        set1.colors = [UIColor.FlatColor.Red.HotPink]
        data.setDrawValues(false)
        
        self.singleFilledLineChart.data = data
        
    }
    
    func setupSingleLineChart() {
        singleFilledLineChart.dragEnabled = false
        singleFilledLineChart.setScaleEnabled(false)
        singleFilledLineChart.pinchZoomEnabled = false
        singleFilledLineChart.maxHighlightDistance = 300
        
        singleFilledLineChart.xAxis.enabled = true
        singleFilledLineChart.xAxis.drawAxisLineEnabled = true
        singleFilledLineChart.xAxis.axisLineColor = .white
        singleFilledLineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        singleFilledLineChart.xAxis.labelTextColor = .white
        
        let yAxis = singleFilledLineChart.leftAxis
        yAxis.labelTextColor = .white
        yAxis.labelPosition = .outsideChart
        yAxis.drawAxisLineEnabled = true
        yAxis.drawGridLinesEnabled = false
        
        singleFilledLineChart.rightAxis.enabled = false
        singleFilledLineChart.leftAxis.enabled = true
        singleFilledLineChart.leftAxis.axisLineColor = .white

        singleFilledLineChart.legend.enabled = false
        
        singleFilledLineChart.chartDescription?.text = ""
        singleFilledLineChart.animate(yAxisDuration: 2.0)
    }
    
    
    func setupDuoLineChart() {
        doubleLineChart.dragEnabled = false
        doubleLineChart.setScaleEnabled(false)
        doubleLineChart.pinchZoomEnabled = false
        doubleLineChart.maxHighlightDistance = 300
        
        doubleLineChart.xAxis.enabled = true
        doubleLineChart.xAxis.drawAxisLineEnabled = true
        doubleLineChart.xAxis.axisLineColor = .white
        doubleLineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        doubleLineChart.xAxis.labelTextColor = .white
        
        let yAxis = doubleLineChart.leftAxis
        yAxis.labelTextColor = .white
        yAxis.labelPosition = .outsideChart
        yAxis.drawAxisLineEnabled = true
        yAxis.drawGridLinesEnabled = false
        
        doubleLineChart.rightAxis.enabled = false
        doubleLineChart.leftAxis.enabled = true
        doubleLineChart.leftAxis.axisLineColor = .white
        
        doubleLineChart.legend.enabled = true
        doubleLineChart.legend.textColor = .white
        
        doubleLineChart.chartDescription?.text = ""
        doubleLineChart.animate(yAxisDuration: 2.0)
    }
    
    func setDataCountDuoLine(_ count: Int, range: UInt32) {
        let yVals1 = (0..<count).map { (i) -> ChartDataEntry in
            let mult = range / 2
            let val = Double(arc4random_uniform(mult) + 350)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let yVals2 = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 450)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: yVals1, label: "Your Spending")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 2.5
        set1.circleRadius = 4
        set1.setCircleColor(.white)
        set1.highlightColor = UIColor.FlatColor.Blue.PastelBlue
        set1.fill = Fill.fillWithColor(UIColor.FlatColor.Blue.PastelBlue.withAlphaComponent(0.6))
        set1.drawFilledEnabled = false
        set1.fillAlpha = 1
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.fillFormatter = CubicLineSampleFillFormatter()
        
        
        let set2 = LineChartDataSet(values: yVals2, label: "Nation Average")
        set2.mode = .cubicBezier
        set2.drawCirclesEnabled = false
        set2.lineWidth = 2.5
        set2.setColor(UIColor.FlatColor.Red.HotPink)
        set2.circleRadius = 4
        set2.setCircleColor(.white)
        set2.highlightColor = UIColor.FlatColor.Red.HotPink
        set2.fill = Fill.fillWithColor(UIColor.FlatColor.Red.HotPink.withAlphaComponent(0.6))
        set2.drawFilledEnabled = false
        set2.fillAlpha = 1
        set2.drawHorizontalHighlightIndicatorEnabled = false
        set2.fillFormatter = CubicLineSampleFillFormatter()
        
        let data = LineChartData(dataSets: [set1, set2])
        data.setValueFont(.systemFont(ofSize: 9))
        data.setDrawValues(false)
        
        doubleLineChart.data = data
    }
    func setupHorizontalBarChart() {
        horizontalBarChart.drawBarShadowEnabled = false
        horizontalBarChart.drawValueAboveBarEnabled = false
        horizontalBarChart.dragEnabled = false
        horizontalBarChart.setScaleEnabled(false)
        horizontalBarChart.pinchZoomEnabled = false
        
        horizontalBarChart.maxVisibleCount = 60
        
        let xAxis  = horizontalBarChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisLineColor = .white
        xAxis.labelTextColor = .white
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 10.0
        
        let leftAxis = horizontalBarChart.leftAxis;
        leftAxis.drawAxisLineEnabled = true;
        leftAxis.drawGridLinesEnabled = false;
        leftAxis.labelTextColor = .white
        leftAxis.axisLineColor = .white
        leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES

        horizontalBarChart.rightAxis.drawAxisLineEnabled = false
        horizontalBarChart.rightAxis.enabled = false
        
        let l = horizontalBarChart.legend
        l.enabled =  false
        
        horizontalBarChart.fitBars = true;
        
        setBarChartDataCount(count: 8, range: 10)
        horizontalBarChart.chartDescription?.text = ""
        horizontalBarChart.animate(yAxisDuration: 2.5)
    }
    
    func setBarChartDataCount(count: Int, range: Double){
        
        let barWidth = 9.0
        let spaceForBar =  10.0;
        
        var yVals = [BarChartDataEntry]()
        
        for i in 0..<count{
            
            let mult = (range + 1)
            let val = (Double)(arc4random_uniform(UInt32(mult)))
            yVals.append(BarChartDataEntry(x: Double(i) * spaceForBar, y: val))
            
        }
        var set1 : BarChartDataSet!
        
        if let count = horizontalBarChart.data?.dataSetCount, count > 0{
            set1 = horizontalBarChart.data?.dataSets[0] as! BarChartDataSet
            set1.values = yVals
            horizontalBarChart.data?.notifyDataChanged()
            horizontalBarChart.notifyDataSetChanged()
            set1.drawValuesEnabled = false
        } else {
            set1 = BarChartDataSet(values: yVals, label: "DataSet")
            var dataSets = [BarChartDataSet]()
            dataSets.append(set1)
            let data = BarChartData(dataSets: dataSets)
            data.barWidth =  barWidth;
            horizontalBarChart.data = data
            set1.drawValuesEnabled = false
        }
    }
    
    
    func setUpVerticalBarChart() {
        barChart.chartDescription?.enabled = false
        barChart.maxVisibleCount = 60
        barChart.pinchZoomEnabled = false
        barChart.drawBarShadowEnabled = false
        barChart.drawValueAboveBarEnabled = false
        
        let xAxis = barChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisLineColor = .white
        xAxis.labelTextColor = .white
        
        let yAxis = barChart.leftAxis
        yAxis.labelPosition = .outsideChart
        yAxis.axisLineColor = .white
        yAxis.labelTextColor = .white
        
        barChart.rightAxis.drawAxisLineEnabled = false
        barChart.rightAxis.enabled = false
        
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
            set1.colors = twoColors
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            barChart.data = data
            barChart.fitBars = true
        }
        
        barChart.setNeedsDisplay()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ChatVC")
        self.present(controller, animated: true, completion: nil)
    }
    
}

extension AnalyticsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return titleLabel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
        }
    
}
