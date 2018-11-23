//
//  LocationManager.swift
//  OurVillages
//
//  Created by Ryan on 2018/11/21.
//  Copyright © 2018 深圳市昊昱显信息技术有限公司. All rights reserved.
//

import Foundation
import SPLog

/// 获取定位信息
public class LocationManager: NSObject, BMKLocationAuthDelegate, BMKLocationManagerDelegate {
    
    public typealias LocationCallback = (BMKLocation?, LocationError?) -> Void
    private var locationManager: BMKLocationManager?
    public var locationCallback: LocationCallback?
    
    private var appKey: String
    public init(appKey: String) {
        self.appKey = appKey
        super.init()
    }
    
    public convenience init(appKey: String, callback: LocationCallback?) {
        self.init(appKey: appKey)
        self.locationCallback = callback
    }
    
    /// 获取我的当前位置
    ///
    /// - Returns: Observable<Address>
    public func locateMe() {
        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: appKey, authDelegate: self)
        let locationManager = BMKLocationManager()
        self.locationManager = locationManager
        locationManager.delegate = self
        locationManager.coordinateType = .BMK09LL
        locationManager.distanceFilter = kCLDistanceFilterNone
        //设置预期精度参数
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //设置应用位置类型
        locationManager.activityType = .automotiveNavigation
        //设置是否自动停止位置更新
        locationManager.pausesLocationUpdatesAutomatically = false
        //设置是否允许后台定位
        locationManager.allowsBackgroundLocationUpdates = true
        //设置位置获取超时时间
        locationManager.locationTimeout = 10
        //设置获取地址信息超时时间
        locationManager.reGeocodeTimeout = 10
        locationManager.locatingWithReGeocode = true
        locationManager.startUpdatingLocation()
    }
    
    public func stopLocatingMe() {
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
    
    public func bmkLocationManager(_ manager: BMKLocationManager, didFailWithError error: Error?) {
        if error != nil {
            SPLog.error("\(self) \(#function) 定位错误回调\(error!)")
            locationCallback?(nil, LocationError.locationManagerError)
        }
    }
    
    public func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
        if location != nil {
            SPLog.info("\(self) \(#function) 位置更新了 \(location!.toString)")
            locationCallback?(location, nil)
            return
        }
        SPLog.error("\(self) \(#function) 位置更新出错\(error!)")
        locationCallback?(location, LocationError.locationManagerError)
    }
    
    public func onCheckPermissionState(_ iError: BMKLocationAuthErrorCode) {
        switch iError {
        case .unknown:
            locationCallback?(nil, LocationError.unknow)
        case .success:
            SPLog.info("\(self) \(#function) 百度地图定位功能开启成功了")
        case .networkFailed:
            locationCallback?(nil, LocationError.networkFailed)
        case .failed:
            locationCallback?(nil, LocationError.permissionDenied)
        }
    }
    
    public func bmkLocationManager(_ manager: BMKLocationManager, didUpdate state: BMKLocationNetworkState, orError error: Error?) {
        SPLog.error("\(self) \(#function) 网络环境变化了")
        printNetworkStatus(networkState: state)
    }
    
    func printNetworkStatus(networkState: BMKLocationNetworkState) {
        switch networkState {
        case .unknown:
            SPLog.info("\(self) \(#line) 未知网络类型")
        case .wifi:
            SPLog.info("\(self) \(#line) 正在使用wifi")
        case .wifiHotSpot:
            SPLog.info("\(self) \(#line) 正在使用wifi热点")
        case .mobile2G:
            SPLog.info("\(self) \(#line) 正在使用2G网络")
        case .mobile3G:
            SPLog.info("\(self) \(#line) 正在使用3G网络")
        case .mobile4G:
            SPLog.info("\(self) \(#line) 正在使用4G网络")
        }
    } 
}

