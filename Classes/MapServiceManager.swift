
//
//  BMKMapHelper.swift
//  OurVillages
//
//  Created by Ryan on 2018/11/22.
//  Copyright © 2018 深圳市昊昱显信息技术有限公司. All rights reserved.
//

import Foundation
import SPLog

/// 链接百度Map服务
/// 请使用MapServiceManager.shared获取实例。
/// 在调用startMapService之前请通过isMapServiceStarted先判断是否已经链接了百度服务
public class MapServiceManager: NSObject, BMKGeneralDelegate {
    
    public typealias OpenMapServiceCallback = (Bool, String?) -> Void
    
    private var appKey: String!
    private var mapManager: BMKMapManager?    
    public var callback: OpenMapServiceCallback?

    private var isPermitted = false
    
    public var isMapServiceStarted: Bool {
        return isPermitted
    }
    
    public static let shared = MapServiceManager()

    private override init() {
        super.init()
    }
    
    func startMapService(appKey: String, callback: OpenMapServiceCallback?) {
        if isPermitted {
            callback?(true, nil)
            return
        }
        mapManager = BMKMapManager()
        let success = mapManager!.start(appKey, generalDelegate: self)
        if !success {
            isPermitted = false
            callback?(false, "百度地图服务开启失败")
        }
    }
    
    /// 停用百度地图服务
    public func stopMapService() {
        mapManager?.stop()
        mapManager = nil
        isPermitted = false
    }
    
   public func onGetPermissionState(_ iError: Int32) {
        if iError == 0 {
            isPermitted = true
            SPLog.info("\(self) \(#function) 百度地图鉴权成功")
            callback?(true, nil)
        } else {
            isPermitted = false
            SPLog.error("\(self) \(#function) 百度地图鉴权失败")
            callback?(false, "百度地图鉴权失败")
        }
    }
}
