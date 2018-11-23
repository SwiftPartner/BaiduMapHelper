//
//  BMKLocationHelper.swift
//  BaiduMapDemo
//
//  Created by Ryan on 2018/11/23.
//  Copyright © 2018 深圳市昊昱显信息技术有限公司. All rights reserved.
//

import Foundation

public extension BMKLocation {    
    public var toString: String {
        let province = rgcData?.province ?? "未知省份"
        let city = rgcData?.city ?? "未知城市"
        let district = rgcData?.district ?? "未知县区"
        var latitude = "未知latitude"
        var longitude = "未知longitude"
        if let lat = location?.coordinate.latitude {
            latitude = String(lat)
        }
        if let lon = location?.coordinate.longitude {
            longitude = String(lon)
        }
        return "\(province) \(city) \(district); latitude = \(latitude) longitude = \(longitude)"
    }
}
