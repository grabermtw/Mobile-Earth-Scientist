//
//  WMS_Capabilities.swift
//  Mobile Earth Scientist
//
//  Created by Matthew William Graber on 4/6/22.
//
//  Giving the WMS_Capabilities struct its own file because it is enormous
//

import XMLCoder

// Struct for decoding the XML returned by the WMS GetCapabilities request.
// Implements Equatable so that equality can be tested
struct WMS_Capabilities: Codable, Equatable {
    static func == (lhs: WMS_Capabilities, rhs: WMS_Capabilities) -> Bool {
        return lhs.capability == rhs.capability
    }
    
    struct Capability: Codable, Equatable {
        static func == (lhs: WMS_Capabilities.Capability, rhs: WMS_Capabilities.Capability) -> Bool {
            return lhs.layerParent == rhs.layerParent
        }
        
        struct LayerParent: Codable, Equatable {
            static func == (lhs: WMS_Capabilities.Capability.LayerParent, rhs: WMS_Capabilities.Capability.LayerParent) -> Bool {
                return (lhs.name == rhs.name) && (lhs.title == rhs.title) && (lhs.layers == rhs.layers)
            }
            
            struct LayerInfo: Codable, Equatable {
                static func == (lhs: WMS_Capabilities.Capability.LayerParent.LayerInfo, rhs: WMS_Capabilities.Capability.LayerParent.LayerInfo) -> Bool {
                    return (lhs.name == rhs.name) && (lhs.title == rhs.title) && (lhs.style == rhs.style)
                }
                
                struct Style: Codable, Equatable {
                    static func == (lhs: WMS_Capabilities.Capability.LayerParent.LayerInfo.Style, rhs: WMS_Capabilities.Capability.LayerParent.LayerInfo.Style) -> Bool {
                        return lhs.legendURL == rhs.legendURL
                    }
                    
                    struct LegendURL: Codable, Equatable {
                        static func == (lhs: WMS_Capabilities.Capability.LayerParent.LayerInfo.Style.LegendURL, rhs: WMS_Capabilities.Capability.LayerParent.LayerInfo.Style.LegendURL) -> Bool {
                            return lhs.onlineResource == rhs.onlineResource
                        }
                        
                        struct OnlineResource: Codable, Equatable {
                            
                            static func == (lhs: WMS_Capabilities.Capability.LayerParent.LayerInfo.Style.LegendURL.OnlineResource, rhs: WMS_Capabilities.Capability.LayerParent.LayerInfo.Style.LegendURL.OnlineResource) -> Bool {
                                return lhs.url == rhs.url
                            }
                            
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
