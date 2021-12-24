//
//  QACalendarArticle.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/09.
//

import Foundation

public struct QACalendarArticle: Codable {
    public let series: String
    public let day: Int
    public let title: String?
    public let url: URL?
    public let author: String?
    
    public init(series: String, day: Int, title: String?, url: URL?, author: String?) {
        self.series = series
        self.day = day
        self.title = title
        self.url = url
        self.author = author
    }
}
