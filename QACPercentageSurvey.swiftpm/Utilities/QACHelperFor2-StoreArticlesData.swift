//
//  QACHelperFor2-StoreArticlesData.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/22.
//

import Foundation
import Kanna

extension QACHelper {
    /// カレンダーにある各種情報・各記事の情報を取得する
    public static func qaCalendarArticles(from calendar: QACalendar) async throws -> (QACalendar, [QACalendarArticle]) {
        let data = try await MyURLSession.shared.data(from: calendar.url)
        let document = try HTML(html: data, encoding: .utf8)
        let calendarMetaData = try qaCalendarMetaData(from: calendar, document: document)
        let articles = qaCalendarArticles(from: document)
        return (calendarMetaData, articles)
    }
    
    private static func qaCalendarMetaData(from calendar: QACalendar, document: HTMLDocument) throws -> QACalendar {
        let xpathToTitle              = "/html/body/div[1]/div[1]/main/div[3]/div[1]/div[1]/h1"
        let xpathToCategory           = "/html/body/div[1]/div[1]/main/div[3]/div[1]/div[1]/div[1]/a[2]"
        let xpathToAuthor             = "/html/body/div[1]/div[1]/main/div[3]/div[1]/div[1]/div[4]/div[2]/div/a[2]/div"
        let xpathToOrganizationAuthor = "/html/body/div[1]/div[1]/main/div[3]/div[1]/div[1]/div[4]/div[2]/a"
        let xpathToParticipants       = "/html/body/div[1]/div[1]/main/div[3]/div[1]/div[1]/div[2]/div[1]/span[1]"
        let xpathToLGTM               = "/html/body/div[1]/div[1]/main/div[3]/div[1]/div[1]/div[2]/div[1]/span[2]"
        let xpathToSubscribers        = "/html/body/div[1]/div[1]/main/div[3]/div[1]/div[1]/div[2]/div[1]/span[3]"
        
        guard let title = document.xpath(xpathToTitle).first?.text,
              let category = document.xpath(xpathToCategory).first?.text,
              let author = document.xpath(xpathToAuthor).first?.text ?? document.xpath(xpathToOrganizationAuthor).first?.text,
              let participants = Int(document.xpath(xpathToParticipants).first?.text ?? ""),
              let lgtm = Int(document.xpath(xpathToLGTM).first?.text ?? ""),
              let subscribers = Int(document.xpath(xpathToSubscribers).first?.text ?? "") else {
                  print("Title:", document.xpath(xpathToTitle).first?.text ?? "nil")
                  print("Category:", document.xpath(xpathToCategory).first?.text ?? "nil")
                  print("Author:", document.xpath(xpathToAuthor).first?.text ?? "nil")
                  print("Participants:", Int(document.xpath(xpathToParticipants).first?.text ?? "") ?? "nil")
                  print("LGTM:", Int(document.xpath(xpathToLGTM).first?.text ?? "") ?? "nil")
                  print("Subscribers:", Int(document.xpath(xpathToSubscribers).first?.text ?? "") ?? "nil")
                  throw Error.failedToParse
              }
        
        return QACalendar(title: title, url: calendar.url, uniqueName: calendar.uniqueName, category: category, author: author, participants: participants, lgtm: lgtm, subscribers: subscribers)
    }
    
    private static func qaCalendarArticles(from document: HTMLDocument) -> [QACalendarArticle] {
        var articles: [QACalendarArticle] = []
        
        let xpathToCalendarSeriesNode = "/html/body/div[1]/div[1]/main/div[3]/div[2]/div[position()]"
        let calendarSeriesNode = document.xpath(xpathToCalendarSeriesNode)
        
        zip(1...calendarSeriesNode.count, calendarSeriesNode).forEach { index, seriesNode in
            let series = "カレンダー\(index)"
            
            let xpathToArticleNodes = "/div[2]/div/table[1]/tbody/tr[position()]/td[position()]"
            let articleNodes = seriesNode.xpath(xpathToArticleNodes)
            for articleNode in articleNodes {
                let xpathToDay = "/p"
                let xpathToAuthor = "/div[1]/div[1]/a"
                let xpathToTitle = "/div[1]/div[2]/a"
                
                guard let day = Int(articleNode.xpath(xpathToDay).first?.text ?? ""),
                      1...25 ~= day else {
                          continue
                      }
                
                let title = articleNode.xpath(xpathToTitle).first?.text
                let url = URL(string: articleNode.xpath(xpathToTitle).first?["href"] ?? "")
                let author = articleNode.xpath(xpathToAuthor).first?.text
                
                let article = QACalendarArticle(series: series, day: day, title: title, url: url, author: author)
                articles.append(article)
            }
        }
        
        return articles
    }
}
