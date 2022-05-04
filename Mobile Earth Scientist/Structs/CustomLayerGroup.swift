//
//  CustomLayerGroup.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 5/3/22.
//

// Used for holding info on layer groups posted to the Science Share
struct CustomLayerGroup {
    let username: String    // username of the uploader
    let uid: String         // uid of the uploader
    let groupName: String   // what the uploader decided to call it
    let layerNames: [String]    // list of the unique layer names used to identify the layers
    let layerTitles: [String]   // list of the layer titles to be displayed in the preview
    let groupId: String
    
    init(username: String, uid: String, groupName: String, layerNames: [String], layerTitles: [String], groupId: String) {
        self.username = username
        self.uid = uid
        self.groupName = groupName
        self.layerNames = layerNames
        self.layerTitles = layerTitles
        self.groupId = groupId
    }
}
