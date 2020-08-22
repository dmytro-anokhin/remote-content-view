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
            NavigationLink(destination: PostDetailView(post: post)) {
                PostRowView(post: post)
            }
        }
    }
}


struct PostRowView : View {

    let post: Post

    var body: some View {
        VStack(alignment: .leading) {
            Text(post.title)
            Text(post.body)
        }
    }
}


struct PostDetailView : View {

    let post: Post

    var body: some View {
        Text(post.body)
            .navigationTitle(post.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}


let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
let content = DecodableRemoteContent(url: url, type: [Post].self)

let liveView =
    NavigationView {
        RemoteContentView(remoteContent: content,
                          progress: {
                            PostsList(posts: Post.listPlaceholder).redacted(reason: .placeholder)
                          },
                          content: {
                            PostsList(posts: $0)
                          })
            .navigationTitle("Posts")
    }
    .navigationViewStyle(StackNavigationViewStyle())


PlaygroundSupport.PlaygroundPage.current.setLiveView(liveView)
