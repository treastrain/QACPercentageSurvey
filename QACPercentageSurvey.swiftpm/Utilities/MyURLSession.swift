//
//  MyURLSession.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/09.
//

import Foundation
import Combine

public class MyURLSession: ObservableObject {
    public static var shared = MyURLSession()
    private init() {}
    
    @MainActor @Published private(set) var waitingURL: URL?
    @MainActor private func set(waitingURL: URL) {
        self.waitingURL = waitingURL
    }
    
    @MainActor @Published private(set) var waitingTime: Int = 0
    @MainActor private func set(waitingTime: Int) {
        self.waitingTime = waitingTime
    }
    
    private var session: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        var userAgent: String {
            fatalError("大量にアクセスすることになるので、連絡先を User-Agent に書いておく")
        }
        configuration.httpAdditionalHeaders = ["User-Agent" : userAgent]
        return URLSession(configuration: configuration)
    }
    
    private var previousDate: Date? = nil
    public func data(from url: URL) async throws -> Data {
        await set(waitingURL: url)
        print(url)
        if let previousDate = previousDate {
            // Qiita API v2 ドキュメント https://qiita.com/api/v2/docs の「利用制限」を参考に、自主的に前回のアクセスから最低 60 秒は間隔を空ける
            let interval = DateInterval(start: previousDate, end: Date())
            let requiredWaitingTime = 60 - Int(interval.duration)
            if requiredWaitingTime > .zero {
                await set(waitingTime: requiredWaitingTime)
                print("\(requiredWaitingTime)秒間 待機中.", terminator: "")
                for _ in 0..<requiredWaitingTime {
                    let seconds = 1
                    try await Task.sleep(nanoseconds: UInt64(seconds) * 1000 * 1000 * 1000)
                    await set(waitingTime: waitingTime - seconds)
                    print(".", terminator: "")
                }
                print("待機終了")
            }
        }
        
        let (data, _) = try await session.data(from: url)
        previousDate = Date()
        return data
    }
}
