//
//  SpeedGraphTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 13.10.2021.
//

import UIKit
import CoreLocation
import Charts
import TinyConstraints

protocol SpeedGraphTableViewCellDelegate: AnyObject {
    func returnSpeedChart(speedChartView: LineChartView)
}

class SpeedGraphTableViewCell: UITableViewCell {
   
    static let identifier = "SpeedGraphTableViewCell"
    public var delegate: SpeedGraphTableViewCellDelegate?
    
    private let graphContainerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = nil
        return imageView
    }()
   
    private let speedHeader : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Speed Graph"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
   
    private let speedChartView : LineChartView = {
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
        lineChartView.xAxis.axisLineColor = .systemOrange
        lineChartView.xAxis.drawGridLinesEnabled = false

        return lineChartView
    }()
   
    private var locationDatas = [CLLocation]()
   
    private var entries = [ChartDataEntry]()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(speedChartView)
        contentView.addSubview(speedHeader)
       
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        let headerHeight = 52
        speedHeader.frame = CGRect(x: 20,
                                   y: 5,
                                   width: Int(contentView.width)/2 - 10,
                                   height: headerHeight)
       
        speedChartView.frame = CGRect(x: 20,
                                      y: speedHeader.bottom,
                                      width: contentView.width - 40,
                                      height: contentView.height-CGFloat(headerHeight))
       
    }
   
    public func configure(with locations: [CLLocation]){
        locationDatas = locations
        setData()
        return
    }
   
    private func setData(){
        var counter = 0.0
        for location in locationDatas{
            let entry = ChartDataEntry(x: counter, y: location.speed)
            counter += 1
            entries.append(entry)
        }
       
        let set1 = LineChartDataSet(entries: entries, label: "")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(.white)
        set1.fill = Fill(color: .systemOrange)
        set1.fillAlpha = 1.0
        set1.drawFilledEnabled = true
       
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        speedChartView.data = data
        delegate?.returnSpeedChart(speedChartView: speedChartView)
    }
   
}
