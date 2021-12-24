//
//  QACalendar.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/06.
//

import Foundation

public struct QACalendar: Codable {
    public let title: String
    public let url: URL
    public let uniqueName: String
    public let category: String?
    public let author: String?
    public let participants: Int?
    public let lgtm: Int?
    public let subscribers: Int?
    
    public init(title: String, urlStringWithoutDomain urlString: String) {
        self.title = title
        self.url = URL(string: "https://qiita.com\(urlString)")!
        self.uniqueName = urlString.replacingOccurrences(of: "/advent-calendar/2021/", with: "")
        self.category = nil
        self.author = nil
        self.participants = nil
        self.lgtm = nil
        self.subscribers = nil
    }
    
    public init(title: String, url: URL, uniqueName: String, category: String, author: String, participants: Int, lgtm: Int, subscribers: Int) {
        self.title = title
        self.url = url
        self.uniqueName = uniqueName
        self.category = category
        self.author = author
        self.participants = participants
        self.lgtm = lgtm
        self.subscribers = subscribers
    }
}
