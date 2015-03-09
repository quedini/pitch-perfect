//
//  RecordedAudio.swift
//  Pitch Pefect
//
//  Created by Joel Lester on 3/6/15.
//  Copyright (c) 2015 Joel Lester. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {

    var filePathUrl: NSURL!
    var title: String!
    
    
    init(filePathTemp: NSURL, titleTemp: String) {
        filePathUrl=filePathTemp
        title=titleTemp
        
    }

}