//
//  MESLayerInfo.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 5/1/22.
//

import Foundation

// Holds information about how a layer is being used in Mobile Earth Scientist
struct MESLayerInfo: Equatable {

    static let wmsImgFormat = "image/png"
    static let imgSize = "1024"
    
    let wmsLayer: WMS_Capabilities.Capability.LayerParent.LayerInfo
    var enabled: Bool = true
    
    var defaultDateStr: String? {
        wmsLayer.dimension?.timeDefault
    }
    
    var defaultDate: Date? {
        
        if let defaultDateStr = defaultDateStr {
            return MESLayerInfo.makeDateFromStr(dateString: defaultDateStr)
        }
        return nil
    }
    
    var dateRangeStr: String? {
        wmsLayer.dimension?.timeRange
    }
    
    // The range of dates this data product is available for
    var dateRange: (Date, Date)? {
        // Some layers have complex date ranges (i.e. not just a start and end, but a start, end, restart, re-end, etc), so we will simplify this by just taking the first and last date in the range.
        // We will also disregard the time interval of the layer because intervals for multiple layers would not necessarily align.
        if let dateRangeStr = dateRangeStr {
            let dateList = dateRangeStr.components(separatedBy: "/")
            if let firstDate = MESLayerInfo.makeDateFromStr(dateString:dateList[0]) {
                if let lastDate = MESLayerInfo.makeDateFromStr(dateString:dateList[dateList.count - 2]) {
                    return (firstDate, lastDate)
                }
            }
        }
        return nil
    }
    
    static func makeDateFromStr(dateString:String) -> Date? {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.date(from: dateString)
    }
    
    // When testing equality, all we care about is the WMS layer.
    // Other info is not important here
    static func == (lhs: MESLayerInfo, rhs: MESLayerInfo) -> Bool {
        return lhs.wmsLayer == rhs.wmsLayer
    }
}
