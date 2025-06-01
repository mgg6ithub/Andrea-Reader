//
//  BookReadingView.swift
//  Andrea
//
//  Created by mgg on 29/5/25.
//

import SwiftUI

struct BookReadingView: View {
    @Binding var book: Book
    
    var body: some View {
        VStack {
            Text(book.title)
                .font(.title)
                .padding()
            
            Text("Página \(book.randomPage) de \(book.totalPages)")
                .font(.subheadline)
            
            ProgressView(value: book.progressFloat)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .frame(width: 200)
            
            HStack {
                Button(action: {
                    if book.randomPage > 1 {
                        book.randomPage -= 1
                        updateProgress()
                    }
                }) {
                    Image(systemName: "minus.circle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    if book.randomPage < book.totalPages {
                        book.randomPage += 1
                        updateProgress()
                    }
                }) {
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                }
            }
            .padding()
        }
        .padding()
        .navigationTitle("Lectura")
        .onChange(of: book.randomPage) {
            updateProgress()
        }
    }
    
    private func updateProgress() {
        book.progressFloat = Float(book.randomPage) / Float(book.totalPages)
        book.progressInt = Int(book.progressFloat * 100)
    }
}

