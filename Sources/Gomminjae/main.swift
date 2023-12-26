import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct Gomminjae: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://your-website-url.com")!
    var name = "Gomminjae"
    var description = "A description of Gomminjae"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try Gomminjae()
    .publish(using: [
        .addMarkdownFiles(),
        .copyResources(),
        .generateHTML(withTheme: .foundation),
        .generateSiteMap(),
        .deploy(using: .gitHub("gomminjae/gomminjae.github.io",
                               branch: "main",
                               useSSH: false)
        )
    ])
