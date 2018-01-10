//
//  JCURL.swift
//  JioCoupons
//
//  Created by Abhishek Singh on 21/06/17.
//  Copyright © 2017 JioMoney. All rights reserved.
//

import UIKit

class JCURL: NSObject {
    
    fileprivate enum JCRelativeURL:String {
        case couponCategory = "/coupons/category"
        case specialCoupons = "/coupons"
        case favouriteCoupons = "/coupons/favorites"
        case nearbyCoupons = "/coupons/nearby"
        case userCouponAddress = "/coupons/user/location"
        case couponWithCouponId = "/coupons/%@/details"
        case redeemCoupon = "/coupons/redeem/%@"
        case syncCoupons = "/coupons/user/0"
        case sendCouponAction = "/coupons/user/%@"
        case allHomeCoupons = "/coupons/home/screen"
    }
    
    
    //MARK: Private
    private static func combinedStringsWith(_ strings:[String]) -> String{
        var concatenatedStr:String = ""
        
        for string in strings {
            concatenatedStr = concatenatedStr + string
        }
        return concatenatedStr
    }
    
    //MARK: Public
    private static func baseURL() -> String {
        return JCConfiguration.sharedInstance.baseUrl
    }
    
    public static func baseURLWithoutLastSlash() -> String {
        var url:String = JCConfiguration.sharedInstance.baseUrl
        let count = (url.characters.count) - 1
        let index = url.index(url.startIndex, offsetBy: count)
        url = url.substring(to: index)
        return url
    }
    
    private static func serverVersion() -> String {
        return "cr/v2"
    }
    
    static func couponCategories() -> String {
        return combinedStringsWith([baseURL(), serverVersion(), JCRelativeURL.couponCategory.rawValue])
    }
    
    static func specialCoupons() -> String{
        return combinedStringsWith([baseURL(), serverVersion(), JCRelativeURL.specialCoupons.rawValue])
    }
    
    static func favouriteCoupons() -> String{
        return combinedStringsWith([baseURL(), serverVersion(), JCRelativeURL.favouriteCoupons.rawValue])
    }
    
    static func allCoupons() -> String{
        return specialCoupons()
    }
    
    static func nearbyCoupons() -> String{
        return combinedStringsWith([baseURL(), serverVersion(), JCRelativeURL.nearbyCoupons.rawValue])
    }
    
    static func userCouponAddress() -> String{
        return combinedStringsWith([baseURL(), serverVersion(), JCRelativeURL.userCouponAddress.rawValue])
    }
    
    static func couponWithCouponId(_ couponId:String) -> String{
        return String(format: combinedStringsWith([baseURL(), serverVersion(), JCRelativeURL.couponWithCouponId.rawValue]), couponId)
    }
    
    static func redeemCouponWithCouponId(_ couponId:String) -> String{
        return String(format: combinedStringsWith([baseURL(), serverVersion(), JCRelativeURL.redeemCoupon.rawValue]), couponId)
    }
    
    static func syncCoupons() -> String{
        return combinedStringsWith([baseURL(), serverVersion(), JCRelativeURL.syncCoupons.rawValue])
    }
    
    static func couponActionWithCouponId(_ couponId:String) -> String{
        return String(format: combinedStringsWith([baseURL(), serverVersion(), JCRelativeURL.sendCouponAction.rawValue]), couponId)
    }
    
    // New Coupon URL's
    static func allHomeCoupons() -> String {
        return String(format: combinedStringsWith([baseURL(), serverVersion(), JCRelativeURL.allHomeCoupons.rawValue]))
    }
}
