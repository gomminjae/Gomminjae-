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
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
        case portfolio
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
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
