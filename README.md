# RemoteContentView

The `RemoteContentView` can download a remote content from a URL and display different loading states.

`RemoteContentView` supports JSON and Plist (using Foundation `Decodable` protocol) and images.

You must provide a view to display the result value, and optionally a view for each loading state.

### Loading and Displaying JSON Data

Displaying the list of posts received from the [JSONPlaceholder](https://jsonplaceholder.typicode.com/posts) API. The `Post` struct conforms to `Codable` protocol used for JSON decoding.

```swift
struct Post : Codable {

    var id: Int

    var title: String

    var body: String
}

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

let content = DecodableRemoteContent(url: url, type: [Post].self, decoder: JSONDecoder())

let view = RemoteContentView(remoteContent: content) { posts in
    List(posts, id: \Post.id) { post in
        VStack {
            Text(post.title)
            Text(post.body)
        }
    }
}
```

### Loading and Displaying an Image

```swift
let url = URL(string: "http://optipng.sourceforge.net/pngtech/img/lena.png")!

let remoteImage = RemoteImage(url: url)

let view = RemoteContentView(remoteContent: remoteImage) {
    Image(uiImage: $0)
}
```


### Loading States

`RemoteContentView` supports 4 customizable loading states:

```swift
let view = RemoteContentView(remoteContent: remoteImage,
                             empty: {
                                EmptyView()
                             },
                             progress: {
                                Text("Loading...")
                             },
                             failure: { errorMessage in
                                Text(errorMessage)
                             },
                             content: { posts in
                                List(posts, id: \Post.id) { post in
                                    VStack {
                                        Text(post.title)
                                        Text(post.body)
                                    }
                                }
                            })

```


