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
    var selectedSelectionID: Site.SectionID?
    
    var body: Component {
        Header {
            Div {
                Text("Gomminjae")
            }.class("logo")
            
            if Site.SectionID.allCases.count > 1 {
                navigation
            }
            
            
        }
    }
    
    private var navigation: Component {
        Navigation {
            List(Site.SectionID.allCases) { sectionID in
                let section = context.sections[sectionID]

                return Link(section.title,
                    url: section.path.absoluteString
                )
                .class(sectionID == selectedSelectionID ? "selected" : "")
            }
        }
    }
    
    
}




