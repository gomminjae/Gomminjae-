//
//  File.swift
//  
//
//  Created by 권민재 on 1/1/24.
//

import Foundation
import Publish
import Plot


struct Banner: Component {
    var title: String
    var subTitle: String
    
    var bannerImage: String = "/Resources/images/space.jpg"
    
    var body: Component {
        Div {
            
            Image(url: bannerImage, description: "배너이미지")
                .class("banner-image")
            
            Text(title)
                .class("banner-title")
            
            Text(subTitle)
                .class("banner-subTitle")
            
            
        }
    }
}
