//
//  ReverseGeoCodeParser.swift
//  BaiduMapDemo
//
//  Created by Ryan on 2018/11/23.
//  Copyright © 2018 深圳市昊昱显信息技术有限公司. All rights reserved.
//

import Foundation
import SPLog

public class ReverseGeoCodeParser: NSObject, BMKGeoCodeSearchDelegate {
    
    public typealias ReverseGeoCodeCallback = (BMKReverseGeoCodeSearchResult?, BMKSearchErrorCode) -> Void
    
    private var mapManager: MapServiceManager!
    
    lazy var geoCodeSearch = BMKGeoCodeSearch()
    var reverseGeoCodeCallback: ReverseGeoCodeCallback?
    
    private var appKey: String
    
    public init(appKey: String) {
        self.appKey = appKey
        super.init()
    }
    
    public convenience init(appKey: String, callback: ReverseGeoCodeCallback?) {
        self.init(appKey: appKey)
        reverseGeoCodeCallback = callback
    }
    
    
    /// 经纬度坐标反编码为地址信息
    ///
    /// - Parameter latLng: latLng 经纬度坐标
    public func reverseGeoCode(geoCode: CLLocationCoordinate2D) {
        MapServiceManager.shared.startMapService(appKey: appKey, callback: {  [weak self] success, errorMsg in
            guard let strongSelf = self else {
                return
            }
            if success {
                SPLog.info("\(strongSelf) \(#function) 百度地图鉴权成功")
                strongSelf.geoCodeSearch.delegate = strongSelf
                let option = BMKReverseGeoCodeSearchOption()
                option.location = geoCode
                let isPassed = strongSelf.geoCodeSearch.reverseGeoCode(option)
                if !isPassed {
                    SPLog.error("\(strongSelf) \(#function) GeoCodeSearch服务启动失败")
                    self?.reverseGeoCodeCallback?(nil, BMK_SEARCH_SERVER_ERROR)
                    return
                }
                SPLog.info("\(strongSelf) \(#function) GeoCodeSearch服务启动成功，等待结果回调")
                return
            }
            SPLog.info("\(strongSelf) \(#function) 百度地图鉴权失败")
            self?.reverseGeoCodeCallback?(nil, BMK_SEARCH_SERVER_ERROR)
        })
    }
    
    public func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
        if error != BMK_SEARCH_NO_ERROR {
            SPLog.error("\(self) \(#function) GeoCode反编码错误\(error)")
            return
        }
        reverseGeoCodeCallback?(result, error)
    }

}
