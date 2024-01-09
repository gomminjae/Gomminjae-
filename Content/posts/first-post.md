---
date: 2023-12-26 15:04
description: A description of my first post.
tags: deploy,xcode,swift
---
# First CI/CD 

My first post's text.

```
private struct ItemTagList<Site: Website>: Component {
    var item: Item<Site>
    var site: Site

    var body: Component {
        List(item.tags) { tag in
            Link(tag.string, url: site.path(for: tag).absoluteString)
                .class(tagClass(for: tag))
        }
        .class("tag-list")
    }
    
    private func tagClass(for tag: Tag) -> String {
        var tagString = tag.string
        return "\(tagString)-tag"
    }
}
```


