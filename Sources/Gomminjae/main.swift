import Foundation
import Publish
import Plot
import SplashPublishPlugin
import Splash


// This will generate your website using the built-in Foundation theme:
try Gomminjae()
    .publish(using: [
        .installPlugin(.splash(withClassPrefix: "")),
        .addMarkdownFiles(),
        .copyResources(),
        .generateHTML(withTheme: .myTheme),
        .generateSiteMap(),
        .deploy(using: .gitHub("gomminjae/gomminjae.github.io",
                               branch: "main",
                               useSSH: false)
        )
    ])
