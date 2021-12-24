//
//  main.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/23.
//

import Foundation
import AppModule

print("StoreCalendarsData")

Task {
    // 全カレンダー数を表示
    let numberOfCalendars = try await QACHelper.numberOfCalendars()
    print("カレンダーの総数は", numberOfCalendars, "です")
    
    // 新着カレンダー一覧の最後のページ番号を取得
    let lastPageNumber = try await QACHelper.lastPageNumberInCalendarList()
    print("新着カレンダー一覧の最後のページ番号は", lastPageNumber, "でした")
    
    // 登録されているすべてのカレンダーの URL を取得
    var calendars: [QACalendar] = []
    for page in lastPageNumber-1...lastPageNumber {
        print("全", lastPageNumber, "ページ中", page, "ページ目の情報を取得します…")
        calendars += try await QACHelper.qaCalendars(page: page)
        print("全", lastPageNumber, "ページ中", page, "ページ目の情報を取得しました")
    }
    
    // JSON ファイルとして保存する
    let calendarsData = QACalendarsData(createdAt: Date(), calendars: calendars)
    try FileHelper.write(to: .calendarsDataJSON, data: calendarsData.encodedData)
    print(FileHelper.FileName.calendarsDataJSON.rawValue, "に書き出しました")
    
    exit(0)
}

RunLoop.current.run()
