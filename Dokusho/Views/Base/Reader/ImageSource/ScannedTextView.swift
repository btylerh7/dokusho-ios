//
//  ScannedTextView.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/16/23.
//

import SwiftUI
import UIKit

struct ScannedTextView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator($text)
    }
    
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.text = text
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 20)
        textView.textContainer.maximumNumberOfLines = 1
        textView.textAlignment = .left
        textView.isEditable = false
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String

        init(_ text: Binding<String>) {
            self._text = text
        }

        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }
    }
}
