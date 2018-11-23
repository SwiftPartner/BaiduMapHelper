//
//  LocationError.swift
//  OurVillages
//
//  Created by Ryan on 2018/11/21.
//  Copyright © 2018 深圳市昊昱显信息技术有限公司. All rights reserved.
//

import Foundation
public enum LocationError: Error {
    case unknow
    case success
    case networkFailed
    case permissionDenied
    case locationManagerError
}
