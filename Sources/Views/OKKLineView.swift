//
//  OKKLineView.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/3.
//  Copyright © 2016年 Herb. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import Cocoa
#endif

class OKKLineView: OKView {
    
    public var doubleTapHandle: (() -> Void)?
    private var klineDrawView: OKKLineDrawView!
    private var timeSegmentView: OKSegmentView!
    private var mainViewIndicatorSegmentView: OKSegmentView!
    private var volumeViewIndicatorSegmentView: OKSegmentView!
    private var accessoryViewIndicatorSegmentView: OKSegmentView!
    private let configuration = OKConfiguration()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        klineDrawView = OKKLineDrawView(configuration: configuration)
        klineDrawView.doubleTapHandle = {
            self.doubleTapHandle?()
        }
        addSubview(klineDrawView)
        klineDrawView.snp.makeConstraints { (make) in
            make.edges.equalTo(OKEdgeInsets(top: 0, left: 0, bottom: 44, right: 50))
        }
        
        let timeTitles = ["分时", "1分", "5分", "15分", "30分", "60分", "日K", "周K", "月K", "季K", "年K"]
        timeSegmentView = OKSegmentView(direction: .horizontal, titles: timeTitles, configuration: configuration)
        timeSegmentView.didSelectedSegment = { [weak self] (segmentView, result) -> Void in
            if result.index == 0 {
                self?.configuration.main.klineType = .timeLine
            } else {
                self?.configuration.main.klineType = .KLine
            }
        
            self?.klineDrawView.drawKLineView(true)
        }
        addSubview(timeSegmentView)
        timeSegmentView.snp.makeConstraints { (make) in
            make.top.equalTo(klineDrawView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        let mainViewIndicatorTitles = ["MA", "EMA", "BOLL"]
        mainViewIndicatorSegmentView = OKSegmentView(direction: .vertical,
                                                     titles: mainViewIndicatorTitles,
                                                     configuration: configuration)
        
        mainViewIndicatorSegmentView.didSelectedSegment = { [weak self] (segmentView, result) -> Void in
            if result.index == 0 {
                self?.configuration.main.indicatorType = .MA([5, 12, 26])
            } else if result.index == 1 {
                self?.configuration.main.indicatorType = .EMA([5, 12, 26])
            } else if result.index == 2 {
                self?.configuration.main.indicatorType = .BOLL(20)
            }
            self?.klineDrawView.drawKLineView(true)
        }
        
        addSubview(mainViewIndicatorSegmentView)
        mainViewIndicatorSegmentView.snp.makeConstraints { (make) in
            make.top.equalTo(klineDrawView.snp.top)
            make.leading.equalTo(klineDrawView.snp.trailing)
            make.trailing.equalToSuperview()
            make.height.equalTo(klineDrawView.snp.height).multipliedBy(configuration.main.scale)
        }
        
        let volumeViewIndicatorTitles = ["MA", "EMA"]
        volumeViewIndicatorSegmentView = OKSegmentView(direction: .vertical,
                                                     titles: volumeViewIndicatorTitles,
                                                     configuration: configuration)
        
        volumeViewIndicatorSegmentView.didSelectedSegment = { [weak self] (segmentView, result) -> Void in
            if result.index == 0 {
                self?.configuration.volume.indicatorType = .MA_VOLUME([5, 12, 26])
            } else if result.index == 1 {
                self?.configuration.volume.indicatorType = .EMA_VOLUME([5, 12, 26])
            }
            self?.klineDrawView.drawKLineView(true)
        }
        
        addSubview(volumeViewIndicatorSegmentView)
        volumeViewIndicatorSegmentView.snp.makeConstraints { (make) in
            make.top.equalTo(mainViewIndicatorSegmentView.snp.bottom)
            make.leading.equalTo(klineDrawView.snp.trailing)
            make.trailing.equalToSuperview()
            make.height.equalTo(klineDrawView.snp.height).multipliedBy(configuration.volume.scale)
        }
        
        let accessoryViewIndicatorTitles = ["MACD", "KDJ"]
        accessoryViewIndicatorSegmentView = OKSegmentView(direction: .vertical,
                                                     titles: accessoryViewIndicatorTitles,
                                                     configuration: configuration)
        
        accessoryViewIndicatorSegmentView.didSelectedSegment = { [weak self] (segmentView, result) -> Void in
            if result.index == 0 {
                self?.configuration.accessory.indicatorType = .MACD
            } else if result.index == 1 {
                self?.configuration.accessory.indicatorType = .KDJ
            } else if result.index == 2 {
                self?.configuration.accessory.indicatorType = .BOLL(20)
            }
            self?.klineDrawView.drawKLineView(true)
        }
        
        addSubview(accessoryViewIndicatorSegmentView)
        accessoryViewIndicatorSegmentView.snp.makeConstraints { (make) in
            make.top.equalTo(volumeViewIndicatorSegmentView.snp.bottom)
            make.leading.equalTo(klineDrawView.snp.trailing)
            make.trailing.equalToSuperview()
            make.height.equalTo(klineDrawView.snp.height).multipliedBy(configuration.accessory.scale)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func drawKLineView(klineModels: [OKKLineModel]) {
        configuration.dataSource.klineModels = klineModels
        klineDrawView.drawKLineView(true)
    }
}
