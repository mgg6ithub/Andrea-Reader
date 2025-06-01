//
//  AppState.swift
//  Andrea
//
//  Created by mgg on 28/5/25.
//

import SwiftUI
import Foundation

struct Collection: Identifiable, Equatable {
    
    let id: UUID
    let title: String
    let color: Color
    let listOfBooks: [Book]
    
}

struct Book: Identifiable, Equatable {
    let id: UUID
    let title: String
    let author: String
    let filePath: String
    let totalPages: Int
    var randomPage: Int
    var progressInt: Int // porcentaje
    var progressFloat: Float //valor entre 0 y 1
    
    init(title: String, author: String, filePath: String) {
        self.id = UUID()
        self.title = title
        self.author = author
        self.filePath = filePath
        self.totalPages = Int.random(in: 20...50)
        self.randomPage = Int.random(in: 1...totalPages)
        self.progressFloat = Float(randomPage) / Float(totalPages) // División flotante
        self.progressInt = Int(progressFloat * 100) // Conversión a porcentaje
    }

    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }
}


class AppEstado: ObservableObject {
    
    @Published var placeholders: [Book?] = []
    private let totalCount = 200
    private let chunkSize = 10
    
    @Published var isFirstTimeLaunch: Bool

    private var currentIndex: Int = 0
    
    init() {
        
        self.isFirstTimeLaunch = true
        
        loadInitialBooks()
        
    }
    
    func loadInitialBooks() {
        let savedIndex = UserDefaults.standard.integer(forKey: "visibleIndex")
        guard savedIndex >= 0 && savedIndex < totalCount else {
            print("Índice guardado fuera de rango, cargando desde 0")
            loadAllFromStart()
            return
        }
        
        DispatchQueue.global().async {
            var forwardIndex = savedIndex
            var backwardIndex = savedIndex - 1
            
            while forwardIndex < self.totalCount || backwardIndex >= 0 {
                // Carga chunk hacia adelante
                if forwardIndex < self.totalCount {
                    let endForward = min(forwardIndex + self.chunkSize, self.totalCount)
                    for i in forwardIndex..<endForward {
                        self.loadBook(at: i)
                    }
                    forwardIndex = endForward
                }
                
                // Carga chunk hacia atrás
                if backwardIndex >= 0 {
                    let startBackward = max(backwardIndex - self.chunkSize + 1, 0)
                    for i in (startBackward...backwardIndex).reversed() {
                        self.loadBook(at: i)
                    }
                    backwardIndex = startBackward - 1
                }
            }
        }
    }
    
    private func loadBook(at index: Int) {
        // Asegúrate de que el array tiene al menos 'index + 1' elementos
        if index >= placeholders.count {
            DispatchQueue.main.async {
                self.placeholders.append(contentsOf: Array(repeating: nil, count: index - self.placeholders.count + 1))
            }
        }
        
        // Crea el libro
        let book = Book(title: "Libro \(index)", author: "Autor \(index)", filePath: "/path/to/book\(index).pdf")
        
        DispatchQueue.main.async {
            self.placeholders[index] = book
        }
        currentIndex += 1
        Thread.sleep(forTimeInterval: 0.07)
    }

    
    public func importMoreBooks(booksToImport: Int) {
        
//        let startIndex = placeholders.count
        
        DispatchQueue.global().async {
            for i in self.currentIndex..<self.currentIndex + booksToImport {
                self.loadBook(at: i)
            }
        }
        
    }

    private func loadAllFromStart() {
        for i in 0..<totalCount {
            loadBook(at: i)
        }
    }
}

