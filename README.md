# RemoteContentView

The `RemoteContentView` can download a remote content from a URL and display different loading states.

The package supports JSON and Plist (using Foundation `Decodable` protocol), images, and custom types.

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

### Implementing Custom RemoteContent

The `RemoteContent` protocol defines objects that provide content and manage loading state. 

```swift
public protocol RemoteContent : ObservableObject {

    associatedtype Item

    var loadingState: RemoteContentLoadingState<Item> { get }

    func load()

    func cancel()
}
```

The package provides two implementations:
- `DecodableRemoteContent` for a content, loaded from a URL, represented by `Decodable` objects;
- `RemoteImage` for images.

You can implement your own `RemoteContent` object if you need custom loading or to make the view work with existing content providers. You can find an example in CustomRemoteContent.playground.
