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
            Paragraph {
                Text(title)
                    
                
            }.class("banner-title")
            
            Paragraph {
                Text(subTitle)
                    
            }.class("banner-subtitle")
            
            
        }
    }
}
