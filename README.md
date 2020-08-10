# RemoteContentView

The `RemoteContentView` can download a remote content from a URL and display different loading states.

`RemoteContentView` supports JSON, image, and custom types. There is also an option to provide a closure to decode data.

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

let view = RemoteContentView(url: url, type: [Post].self) { posts in
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

let view = RemoteContentView(url: url, type: UIImage.self) {
    Image(uiImage: $0)
}
```

### Loading and Displaying custom types

You can provide `decode` closure to control decoding routine.

```swift
let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

let view = RemoteContentView(url: url, decode: { data in
    String(data: data, encoding: .utf8) ?? ""
}) { string in
    Text(string)
}
```

Alternatively, you can confirm a type to `RemoteContentDecodable` protocol by implementing `init?(data: Data)`.


### Loading States

`RemoteContentView` supports 4 customizable loading states:

```swift
let view = RemoteContentView(url: url, type: [Post].self,
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


