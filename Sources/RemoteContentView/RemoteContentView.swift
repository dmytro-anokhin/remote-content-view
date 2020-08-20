//
//  RemoteContentView.swift
//  
//
//  Created by Dmytro Anokhin on 09/08/2020.
//

import SwiftUI
import Combine


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct RemoteContentView<Value, Empty, Progress, Failure, Content> : View where Empty : View,
                                                                                      Progress : View,
                                                                                      Failure : View,
                                                                                      Content : View
{
    let empty: () -> Empty

    let progress: () -> Progress

    let failure: (_ error: Error, _ retry: @escaping () -> Void) -> Failure

    let content: (_ value: Value) -> Content

    public init<R: RemoteContent>(remoteContent: R,
                                  empty: @escaping () -> Empty,
                                  progress: @escaping () -> Progress,
                                  failure: @escaping (_ error: Error, _ retry: @escaping () -> Void) -> Failure,
                                  content: @escaping (_ value: Value) -> Content) where R.ObjectWillChangePublisher == ObservableObjectPublisher,
                                                                                        R.Value == Value
    {
        self.remoteContent = AnyRemoteContent(remoteContent)

        self.empty = empty
        self.progress = progress
        self.failure = failure
        self.content = content
    }

    public var body: some View {
        ZStack {
            switch remoteContent.loadingState {
                case .initial:
                    empty()

                case .inProgress:
                    progress()

                case .success(let value):
                    content(value)

                case .failure(let error):
                    failure(error) {
                        remoteContent.load()
                    }
            }
        }
        .onAppear {
            remoteContent.load()
        }
        .onDisappear {
            remoteContent.cancel()
        }
    }

    @ObservedObject private var remoteContent: AnyRemoteContent<Value>
}
