import PlaygroundSupport
import SwiftUI
import RemoteContentView


struct Post : Codable {

    var id: Int

    var title: String

    var body: String
}


extension Post {

    static let listPlaceholder: [Post] = [ Post(id: -1, title: "Lorem ipsum", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.") ]
}


struct PostsList : View {

    let posts: [Post]

    var body: some View {
        List(posts, id: \Post.id) { post in
            NavigationLink(destination: PostView()) {
                VStack(alignment: .leading) {
                    Text(post.title)
                        .lineLimit(1)
                    Text(post.body)
                        .lineLimit(2)
                }
            }
        }
    }
}


struct PostView : View {

    var body: some View {
        Text("Post")
    }
}


struct PostsView : View {

    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

    var body: some View {
        RemoteContentView(url: url,
                          type: [Post].self,
                          decoder: JSONDecoder(),
                          progress: {
                            PostsList(posts: Post.listPlaceholder)
                                .redacted(reason: .placeholder)
                          },
                          content: {
                            PostsList(posts: $0)
                          })
    }
}

let liveView =
    //NavigationV(destination: PostView()) {
    NavigationView {
        PostsView()
    }
    .navigationTitle("Posts")
    .navigationViewStyle(StackNavigationViewStyle())


PlaygroundSupport.PlaygroundPage.current.setLiveView(liveView)
