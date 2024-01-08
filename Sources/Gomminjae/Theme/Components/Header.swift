//
//  File.swift
//  
//
//  Created by 권민재 on 1/8/24.
//
import Publish
import Plot

struct HeaderComponent<Site: Website>: Component {
    
    var context: PublishingContext<Site>
    var selectedSectionID: Site.SectionID?
    
    var body: Component {
        Header {
            
        }
    }
}
