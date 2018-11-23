//
//  GeoCodeParser.swift
//  OurVillages
//
//  Created by Ryan on 2018/11/22.
//  Copyright © 2018 深圳市昊昱显信息技术有限公司. All rights reserved.
//

import Foundation
import SPLog

public class GeoCodeParser: NSObject, BMKGeoCodeSearchDelegate {
    
    public typealias GeoCodeCallback = (BMKGeoCodeSearchResult?, BMKSearchErrorCode) -> Void
    
    private lazy var geoCodeSearch = BMKGeoCodeSearch()
    private var mapManager: MapServiceManager!
    
    public var geoCodeCallback: GeoCodeCallback?
    
    private var appKey: String
    
    public init(appKey: String) {
        self.appKey = appKey
        super.init()
    }
    
    public convenience init(appKey: String, callback: GeoCodeCallback?) {
        self.init(appKey: appKey)
        geoCodeCallback = callback
    }
    
    /// 通过地址获取经纬度坐标
    ///
    /// - Parameters:
    ///   - city: 城市名
    ///   - address: 详细地址
    public func getGeoCode(city: String, address: String) {
        if MapServiceManager.shared.isMapServiceStarted {
            SPLog.info("\(self) \(#function) 百度地图已经鉴权成功，不许要再次鉴权")
            getGeoCodeDirectly(city: city, address: address)
            return
        }
        MapServiceManager.shared.startMapService(appKey: appKey, callback: { [weak self] success, errorMsg in
            guard let strongSelf = self else {
                return
            }
            if success {
                SPLog.info("\(strongSelf) \(#function) 百度地图鉴权成功")
                self?.getGeoCodeDirectly(city: city, address: address)
                return
            }
            SPLog.info("\(strongSelf) \(#function) 百度地图鉴权失败")
            self?.geoCodeCallback?(nil, BMK_SEARCH_SERVER_ERROR)
        })
    }
    
    private func getGeoCodeDirectly(city: String, address: String) {
        geoCodeSearch.delegate = self
        let option = BMKGeoCodeSearchOption()
        option.city = city
        option.address = address
        let isPassed = geoCodeSearch.geoCode(option)
        if !isPassed {
            SPLog.error("\(self) \(#function) GeoCodeSearch服务启动失败")
            geoCodeCallback?(nil, BMK_SEARCH_SERVER_ERROR)
            return
        }
        SPLog.info("\(self) \(#function) GeoCodeSearch服务启动成功，等待结果回调")
    }
    
    public func onGetGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
        if error != BMK_SEARCH_NO_ERROR {
            SPLog.error("\(self) \(#function) GeoCode编码错误\(error)")
            geoCodeCallback?(nil, error)
            return
        }
        SPLog.info("\(self) \(#function) GeoCode编码完成：纬度： \(result.location.latitude) ；经度： \(result.location.longitude)")
        geoCodeCallback?(result, error)
    }
}
