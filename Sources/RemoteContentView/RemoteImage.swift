//
//  RemoteImage.swift
//  
//
//  Created by Dmytro Anokhin on 19/08/2020.
//

import UIKit
import Combine


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public final class RemoteImage : RemoteContent {

    public unowned let urlSession: URLSession

    public let url: URL

    public init(urlSession: URLSession = .shared, url: URL) {
        self.urlSession = urlSession
        self.url = url
    }

    @Published private(set) public var loadingState: RemoteContentLoadingState<UIImage> = .none

    public func load() {
        guard cancellable == nil else {
            return
        }

        // Set state to in progress
        loadingState = .inProgress

        // Start loading
        cancellable = urlSession
            .dataTaskPublisher(for: url)
            .map {
                guard let value = UIImage(data: $0.data) else {
                    return .failure("Failed to decode the image")
                }

                return .success(value)
            }
            .catch {
                Just(.failure($0.localizedDescription))
            }
            .receive(on: RunLoop.main)
            .assign(to: \.loadingState, on: self)
    }

    public func cancel() {
        guard cancellable != nil else {
            return
        }

        // Reset loading state
        loadingState = .none

        // Stop loading
        cancellable?.cancel()
        cancellable = nil
    }

    private var cancellable: AnyCancellable?

}

