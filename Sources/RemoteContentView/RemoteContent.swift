//
//  RemoteContent.swift
//
//
//  Created by Dmytro Anokhin on 09/08/2020.
//

import Combine
import Foundation


/// The state of the loading process.
///
/// The `RemoteContentLoadingState` serves dual purpose:
/// - represents the state of the loading process: none, in progress, success or failure;
/// - keeps associated value relevant to the state of the loading process.
///
/// This dual purpose allows `View` to switch over the state in its `body` and return different view in each case.
///
public enum RemoteContentLoadingState<T> {

    case none

    case inProgress

    case success(_ value: T)

    case failure(_ message: String)
}


public protocol RemoteContent : ObservableObject {

    associatedtype Item

    var loadingState: RemoteContentLoadingState<Item> { get }

    func load()

    func cancel()
}


final class AnyRemoteContent<Item> : RemoteContent {

    init<R: RemoteContent>(_ remoteContent: R) where R.ObjectWillChangePublisher == ObjectWillChangePublisher, R.Item == Item {
        objectWillChangeClosure = {
            remoteContent.objectWillChange
        }

        loadingStateClosure = {
            remoteContent.loadingState
        }

        loadClosure = {
            remoteContent.load()
        }

        cancelClosure = {
            remoteContent.cancel()
        }
    }

    private let objectWillChangeClosure: () -> ObjectWillChangePublisher

    var objectWillChange: ObservableObjectPublisher {
        objectWillChangeClosure()
    }

    private let loadingStateClosure: () -> RemoteContentLoadingState<Item>

    var loadingState: RemoteContentLoadingState<Item> {
        loadingStateClosure()
    }

    private let loadClosure: () -> Void

    func load() {
        loadClosure()
    }

    private let cancelClosure: () -> Void

    func cancel() {
        cancelClosure()
    }
}


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public final class DecodableRemoteContent<Item, Decoder> : RemoteContent where Item : Decodable, Decoder : TopLevelDecoder, Decoder.Input == Data {

    public unowned let urlSession: URLSession

    public let url: URL

    public let type: Item.Type

    public let decoder: Decoder

    public init(urlSession: URLSession = .shared, url: URL, type: Item.Type, decoder: Decoder) {
        self.urlSession = urlSession
        self.url = url
        self.type = type
        self.decoder = decoder
    }

    @Published private(set) public var loadingState: RemoteContentLoadingState<Item> = .none

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
                $0.data
            }
            .decode(type: type, decoder: decoder)
            .map {
                .success($0)
            }
//            .map { result in
//                // Decode
//                do {
//                    let value = try self.decode(result.data)
//                    return .success(value)
//                }
//                catch {
//                    return .failure("\(error)")
//                }
//            }
            .catch {// error -> Just<LoadingState<T>> in
                Just(.failure($0.localizedDescription))
                // Process error
                //Just(.failure(error.localizedDescription))
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
