//
//  2-StoreArticlesDataView.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/21.
//

import SwiftUI

@MainActor
struct StoreArticlesDataView: View {
    @ObservedObject private var session = MyURLSession.shared
    
    @State private var isExecuting = false
    @State private var hasBeenExecutedMoreThanOnce = false
    
    @State private var isPresentedToFileImporter = false
    @State private var errorDescriptionReadImportFile: String? = nil
    
    @State private var articlesDataResults: [(String, Result<URL, Error>)] = []
    
    private var outputURL: URL? = nil
    @State private var isPresentedToActivityView = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button {
                        Task {
                            do {
                                // _calendarsData.json からデータを持ってくる
                                await execute(with: try FileHelper.read(from: .calendarsDataJSON))
                            } catch {
                                print(error)
                                errorDescriptionReadImportFile = error.localizedDescription
                            }
                        }
                    } label: {
                        Label {
                            Image(systemName: "1.circle")
                            Text("のデータを用いて実行")
                        } icon: {
                            Image(systemName: "doc.text")
                        }
                    }
                    .disabled(isExecuting)
                    Button {
                        isPresentedToFileImporter.toggle()
                    } label: {
                        Label("JSON ファイルを指定して実行", systemImage: "square.and.arrow.down")
                    }
                    .disabled(isExecuting)
                } footer: {
                    if let str = errorDescriptionReadImportFile { Text(str) }
                }
                if hasBeenExecutedMoreThanOnce {
                    Section {
                        HStack {
                            Text("\(MyURLSession.shared.waitingURL?.absoluteString ?? "なし")")
                        }
                    } header: {
                        Text("\(MyURLSession.shared.waitingTime) 秒後に接続します…")
                            .monospacedDigit()
                    }
                    Section {
                        HStack {
                            Text("ファイルの読み込み")
                            Spacer()
                            Image(systemName: errorDescriptionReadImportFile == nil ? "checkmark.circle" : "xmark.octagon")
                        }
                    } header: {
                        Text("ファイルの読み込み")
                    } footer: {
                        if let str = errorDescriptionReadImportFile { Text(str) }
                    }
                    Section {
                        ForEach(articlesDataResults, id: \.0) { title, result in
                            HStack {
                                Text(title)
                                Spacer()
                                Image(systemName: (try? result.get()) != nil ? "checkmark.circle" : "xmark.octagon")
                            }
                        }
                    } header: {
                        Text("ファイルの書き出し")
                    }
                    Section {
                        Button {
                            isPresentedToActivityView.toggle()
                        } label: {
                            Label("出力結果を別な場所に書き出す", systemImage: "square.and.arrow.up")
                        }
                        .disabled(isExecuting)
                    }
                }
            }
            .navigationTitle("Store Articles Data")
        }
        .fileImporter(isPresented: $isPresentedToFileImporter, allowedContentTypes: [.json]) { result in
            Task {
                do {
                    let url = try result.get()
                    await execute(with: try FileHelper.read(from: url))
                } catch {
                    print(error)
                    errorDescriptionReadImportFile = error.localizedDescription
                }
            }
        }
        .sheet(isPresented: $isPresentedToActivityView) {
            let urls = articlesDataResults.compactMap { try? $1.get() }
            ActivityView(activityItems: urls)
        }
    }
    
    private func execute(with data: Data) async {
        isExecuting = true
        hasBeenExecutedMoreThanOnce = true
        
        let calendarsData = QACalendarsData(from: data)
        var failedCalendars: [QACalendar] = []
        
        // 各カレンダーの情報を取得し、JSON に書き出す
        for calendar in calendarsData.calendars {
            let calendarMetaData: QACalendar
            let articles: [QACalendarArticle]
            do {
                print("\"\(calendar.title)\"", "の情報を取得します…")
                (calendarMetaData, articles) = try await QACHelper.qaCalendarArticles(from: calendar)
                print("\"\(calendarMetaData.title)\"", "の情報を取得に成功しました")
            } catch {
                print("\"\(calendar.title)\"", "の情報を取得に失敗しました", error)
                failedCalendars.append(calendar)
                articlesDataResults.insert((calendar.title, .failure(error)), at: 0)
                continue
            }
            
            let articlesData = QACalendarArticlesData(createdAt: Date(), calendarMetaData: calendarMetaData, articles: articles)
            let fileName = "\(calendar.uniqueName).json"
            do {
                let url = try FileHelper.write(to: .custom(fileName), data: articlesData.encodedData)
                print(fileName, "に書き出しました")
                articlesDataResults.insert((calendarMetaData.title, .success(url)), at: 0)
            } catch {
                print(fileName, "の書き出しに失敗しました", error)
                articlesDataResults.insert((calendarMetaData.title, .failure(error)), at: 0)
            }
        }
        
        do {
            let failedCalendarsData = QACalendarsData(createdAt: Date(), calendars: failedCalendars)
            let url = try FileHelper.write(to: .failedCalendarsDataJSON, data: failedCalendarsData.encodedData)
            articlesDataResults.append(("Failed Calendars Data", .success(url)))
        } catch {
            print(error)
            articlesDataResults.append(("Failed Calendars Data", .failure(error)))
        }
        
        isExecuting = false
    }
}
