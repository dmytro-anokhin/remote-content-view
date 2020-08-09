import PlaygroundSupport
import SwiftUI
import RemoteContentView


let url = URL(string: "http://optipng.sourceforge.net/pngtech/img/lena.png#\(UUID().uuidString)")!

let view = RemoteContentView(url: url, type: UIImage.self) {
    Image(uiImage: $0)
}

PlaygroundSupport.PlaygroundPage.current.setLiveView(view)
