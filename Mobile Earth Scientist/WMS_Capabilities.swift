//
//  WMS_Capabilities.swift
//  Mobile Earth Scientist
//
//  Created by Matthew William Graber on 4/6/22.
//
//  Giving the WMS_Capabilities struct its own file because it is enormous
//

import Foundation
import XMLCoder

let wmsCapabilitiesURL = "https://gibs.earthdata.nasa.gov/wms/epsg4326/best/wms.cgi?SERVICE=WMS&REQUEST=GetCapabilities&VERSION=1.3.0"

// Struct for decoding the XML returned by the WMS GetCapabilities request
struct WMS_Capabilities: Codable {
    struct Capability: Codable {
        struct LayerParent: Codable {
            struct LayerType: Codable {
                struct LayerInfo: Codable {
                    struct Style: Codable {
                        struct LegendURL: Codable {
                            struct OnlineResource: Codable {
                                var url: String
                                enum CodingKeys: String, CodingKey {
                                    case url = "xlink:href"
                                }
                                static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
                                    switch key {
                                        case OnlineResource.CodingKeys.url: return .attribute
                                    default: return .attribute
                                    }
                                }
                            }
                            var onlineResource: OnlineResource
                            enum CodingKeys: String, CodingKey {
                                case onlineResource = "OnlineResource"
                            }
                        }
                        var legendURL: LegendURL
                        enum CodingKeys: String, CodingKey {
                            case legendURL = "LegendURL"
                        }
                    }
                    var name: String
                    var title: String
                    var style: Style?
                    enum CodingKeys: String, CodingKey {
                        case name = "Name"
                        case title = "Title"
                        case style = "Style"
                    }
                }
                var name: String
                var title: String
                var layers: [LayerInfo]
                enum CodingKeys: String, CodingKey {
                    case name = "Name"
                    case title = "Title"
                    case layers = "Layer"
                }
            }
            var layers: [LayerType]
            enum CodingKeys: String, CodingKey {
                case layers = "Layer"
            }
        }
        var layerParent: LayerParent
        enum CodingKeys: String, CodingKey {
            case layerParent = "Layer"
        }
    }
    let capability: Capability
    enum CodingKeys: String, CodingKey {
        case capability = "Capability"
    }
}
