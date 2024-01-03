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
    
    var bannerImage: String
    
    var body: Component {
        Div {
            
            
            Link(url: "/") {
                Image(url: bannerImage, description: "배너이미지")
                .class("banner-image")
            }
            Paragraph {
                Text(title)
                    
                
            }.class("banner-title")
            
            Paragraph {
                Text(subTitle)
                    
            }.class("banner-subtitle")
            
            
        }
    }
}
