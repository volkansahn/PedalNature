//
//  ElevationGraphTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 13.10.2021.
//

import UIKit
import Charts
import TinyConstraints
import CoreLocation

protocol ElevationGraphTableViewCellDelegate: AnyObject {
    func returnElevationChart(elevationChartView: LineChartView)
}

class ElevationGraphTableViewCell: UITableViewCell, ChartViewDelegate {

    static let identifier = "ElevationGraphTableViewCell"
    public var delegate: ElevationGraphTableViewCellDelegate?
    private let elevationHeader : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Elevation Graph"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
   
    private let elevationChartView : LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.backgroundColor = .systemBackground
        lineChartView.rightAxis.enabled = false
        lineChartView.isUserInteractionEnabled = false
       
        let yAxis = lineChartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .label
        yAxis.axisLineColor = .label
        yAxis.labelPosition = .outsideChart
        yAxis.drawGridLinesEnabled = false
       
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChartView.xAxis.setLabelCount(6, force: false)
        lineChartView.xAxis.labelTextColor = .label
        lineChartView.xAxis.axisLineColor = .systemBlue
        lineChartView.xAxis.drawGridLinesEnabled = false

        return lineChartView
    }()
   
    private var locationDatas = [CLLocation]()
   
    private var entries = [ChartDataEntry]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(elevationHeader)
        contentView.addSubview(elevationChartView)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        let headerHeight = 52
        elevationHeader.frame = CGRect(x: 20,
                                       y: 5,
                                       width: Int(contentView.width)/2-10,
                                       height: headerHeight)
       
        elevationChartView.frame = CGRect(x: 20,
                                          y: elevationHeader.bottom,
                                          width: contentView.width-40,
                                          height: contentView.height - CGFloat(headerHeight))
 
    }
   
    public func configure(with locations: [CLLocation]){
        locationDatas = locations
        setData()
        //graphContainerImageView.image = UIImage(named: "test")
        return
       
    }
   
    private func setData(){
        var counter = 0.0
        for location in locationDatas{
            let entry = ChartDataEntry(x: counter, y: location.altitude)
            counter += 1
            entries.append(entry)
        }
        let set1 = LineChartDataSet(entries: entries, label: "")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(.white)
        set1.fill = Fill(color: .systemBlue)
        set1.fillAlpha = 1.0
        set1.drawFilledEnabled = true
       
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        elevationChartView.data = data
        delegate?.returnElevationChart(elevationChartView: elevationChartView)
    }
   
}
