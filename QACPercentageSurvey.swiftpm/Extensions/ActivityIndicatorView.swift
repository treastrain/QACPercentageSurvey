//
//  ActivityIndicatorView.swift
//  QACPercentageSurvey
//
//  Created by treastrain on 2021/12/21.
//

#if os(iOS) || os(tvOS)
import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .medium)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
        uiView.startAnimating()
    }
}
#endif
