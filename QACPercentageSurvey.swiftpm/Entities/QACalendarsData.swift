//
//  QACalendarsData.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/06.
//

import Foundation

public struct QACalendarsData: Codable {
    public let createdAt: Date
    public let calendars: [QACalendar]
    
    public init(createdAt: Date, calendars: [QACalendar]) {
        self.createdAt = createdAt
        self.calendars = calendars
    }
    
    public init(from data: Data) {
        self = try! JSONDecoder.default.decode(Self.self, from: data)
    }
    
    public var encodedData: Data {
        return try! JSONEncoder.default.encode(self)
    }
}
