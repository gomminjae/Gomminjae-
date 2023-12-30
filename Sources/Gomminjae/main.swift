import Foundation
import Publish
import Plot
import SplashPublishPlugin

// This will generate your website using the built-in Foundation theme:
try Gomminjae()
    .publish(using: [
        .installPlugin(.splash(withClassPrefix: "")),
        .addMarkdownFiles(),
        .copyResources(),
        .generateHTML(withTheme: .foundation),
        .generateSiteMap(),
        .deploy(using: .gitHub("gomminjae/gomminjae.github.io",
                               branch: "main",
                               useSSH: false)
        )
    ])
