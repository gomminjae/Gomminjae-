//
//  File.swift
//  
//
//  Created by 권민재 on 12/30/23.
//
import Foundation
import Publish
import Plot




struct Gomminjae: Website {
    
    //웹사이트 SectionID
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
        case portfolio
        case about
        
        var name: String {
            switch self {
            case .posts: return "Posts"
            case .about: return "About"
            case .portfolio: return "Portfolio"
                
            }
        }
    }

    //웹사이트 메타데이터 
    struct ItemMetadata: WebsiteItemMetadata {
        var date: Date
        var description: String
        var tags: Tag
    }


    // Update these properties to configure your website:
    var url = URL(string: "https://gomminjae/gomminjae.github.io")!
    var name = "Gomminjae"
    var description = "A description of Gomminjae"
    var language: Language { .english }
    var imagePath: Path? { nil }
}
