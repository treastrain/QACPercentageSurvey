//
//  QACalendarArticlesData.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/09.
//

import Foundation

public struct QACalendarArticlesData: Codable {
    public let createdAt: Date
    public let calendarMetaData: QACalendar
    public let articles: [QACalendarArticle]
    
    public init(createdAt: Date, calendarMetaData: QACalendar, articles: [QACalendarArticle]) {
        self.createdAt = createdAt
        self.calendarMetaData = calendarMetaData
        self.articles = articles
    }
    
    public init(from data: Data) {
        self = try! JSONDecoder.default.decode(Self.self, from: data)
    }
    
    public var encodedData: Data {
        return try! JSONEncoder.default.encode(self)
    }
}
