//
//  QACHelperFor1-StoreCalendarsData.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/22.
//

import Foundation
import Kanna

extension QACHelper {
    /// Qiita Advent Calendar の総数を調べる
    public static func numberOfCalendars() async throws -> Int {
        let lastPageNumber = try await lastPageNumberInCalendarList()
        let numberOfCalendarsOnTheLastPage: Int = try await {
            // 新着カレンダー一覧の最後のページにアクセスする
            let url = calendarsListURL(page: lastPageNumber)
            let data = try await MyURLSession.shared.data(from: url)
            
            // 新着カレンダー一覧の最後のページにいくつカレンダーがあるかを数える
            let document = try HTML(html: data, encoding: .utf8)
            let xpath = "/html/body/div[1]/div[1]/main/div[3]/section/div/div[position()]"
            let object = document.xpath(xpath)
            return object.count
        }()
        
        // 1ページに20個の Advent Calendar が登録されている
        return (lastPageNumber - 1) * 20 + numberOfCalendarsOnTheLastPage
    }
    
    /// 新着カレンダー一覧の最後のページ番号
    public static func lastPageNumberInCalendarList() async throws -> Int {
        // 新着カレンダー一覧の1ページ目にアクセスする
        let url = calendarsListURL(page: 1)
        let data = try await MyURLSession.shared.data(from: url)
        
        // 最後が何ページ目になるのかを取得する
        let document = try HTML(html: data, encoding: .utf8)
        let xpath = "/html/body/div[1]/div[1]/main/div[3]/section/ul/li[2]"
        
        guard let text = document.xpath(xpath).first?.text else {
            throw Error.failedToParse
        }
        let lastPageNumberString = text.replacingOccurrences(of: "1 / ", with: "")
        return Int(lastPageNumberString)!
    }
    
    /// カレンダー一覧にあるカレンダータイトルとカレンダー URL を取得する
    public static func qaCalendars(page: Int) async throws -> [QACalendar] {
        var qaCalendars: [QACalendar] = []
        
        let url = calendarsListURL(page: page)
        let data = try await MyURLSession.shared.data(from: url)
        let document = try HTML(html: data, encoding: .utf8)
        for index in 1...20 {
            let xpathToParticipants = "/html/body/div[1]/div[1]/main/div[3]/section/div/div[\(index)]/div/div[1]/div/div/span[1]"
            let xpathToTitle = "/html/body/div[1]/div[1]/main/div[3]/section/div/div[\(index)]/div/div[1]/div/p"
            let xpathToURL = "/html/body/div[1]/div[1]/main/div[3]/section/div/div[\(index)]/div/a"
            
            // 参加者が0人のカレンダーは除外する
            guard Int(document.xpath(xpathToParticipants).first?.text ?? "") ?? 0 != .zero else {
                continue
            }
            
            guard let title = document.xpath(xpathToTitle).first?.text,
                  let urlStringWithoutDomain = document.xpath(xpathToURL).first?["href"] else {
                      continue
                  }
            
            let qaCalendar = QACalendar(title: title, urlStringWithoutDomain: urlStringWithoutDomain)
            qaCalendars.append(qaCalendar)
        }
        
        return qaCalendars
    }
}

fileprivate extension QACHelper {
    /// 新着カレンダー一覧の URL
    static func calendarsListURL(page: Int) -> URL {
        return URL(string: "https://qiita.com/advent-calendar/2021/calendars?page=\(page)")!
    }
}
