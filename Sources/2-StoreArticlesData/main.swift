//
//  main.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/23.
//

import Foundation
import AppModule

print("StoreArticlesData")

Task {
    // _calendarsData.json からデータを持ってくる
    let data = try FileHelper.read(from: .calendarsDataJSON)
    let calendarsData = QACalendarsData(from: data)
    var failedCalendars: [QACalendar] = []
    
    // 各カレンダーの情報を取得し、JSON に書き出す
    for calendar in calendarsData.calendars {
        let calendarMetaData: QACalendar
        let articles: [QACalendarArticle]
        do {
            print("\"\(calendar.title)\"", "の情報を取得します…")
            (calendarMetaData, articles) = try await QACHelper.qaCalendarArticles(from: calendar)
        } catch {
            print("\"\(calendar.title)\"", "の情報を取得に失敗しました")
            failedCalendars.append(calendar)
            continue
        }
        
        print("\"\(calendar.title)\"", "の情報を取得に成功しました")
        
        let articlesData = QACalendarArticlesData(createdAt: Date(), calendarMetaData: calendarMetaData, articles: articles)
        let fileName = "\(calendar.uniqueName).json"
        try FileHelper.write(to: .custom(fileName), data: articlesData.encodedData)
        print(fileName, "に書き出しました")
    }
    
    let failedCalendarsData = QACalendarsData(createdAt: Date(), calendars: failedCalendars)
    try FileHelper.write(to: .failedCalendarsDataJSON, data: failedCalendarsData.encodedData)
    
    exit(0)
}

RunLoop.current.run()
