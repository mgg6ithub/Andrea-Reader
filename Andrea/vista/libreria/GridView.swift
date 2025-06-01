//
//  GridView.swift
//  Andrea
//
//  Created by mgg on 28/5/25.
//

import SwiftUI

struct GridView: View {
    
    @EnvironmentObject var appState: AppEstado
    @EnvironmentObject var appEstado: AppEstado1
    @State private var visibleIndex: Int = 0
    
    var body: some View {
        GeometryReader { outerGeometry in
            ScrollViewReader { scrollProxy in
                ScrollView(.vertical) {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.adaptive(minimum: 150)), count: Int(outerGeometry.size.width / 150)),
                        spacing: 20
                    ) {
                        ForEach(appState.placeholders.indices, id: \.self) { index in
                            Group {
                                if let _ = appState.placeholders[index] {
                                    // Crear un binding no opcional para BookView / BookItemView
                                    BookItemView(book: Binding(
                                        get: { appState.placeholders[index]! }, // seguro porque validamos que no es nil
                                        set: { newValue in appState.placeholders[index] = newValue }
                                    ))
                                    .frame(width: 150, height: 200)
                                } else {
                                    PlaceholderView()
                                        .frame(width: 150, height: 200)
                                }
                            }
                            .id(index) // asignar id para scrollTo
                            .background(
                                GeometryReader { geo -> Color in
                                    DispatchQueue.main.async {
                                        let minX = geo.frame(in: .global).minX
                                        let screenWidth = UIScreen.main.bounds.width
                                        // Si el elemento está visible en la pantalla (ajusta el rango como quieras)
                                        if minX > 0 && minX < screenWidth / 2 {
                                            if visibleIndex != index {
                                                visibleIndex = index

                                                if visibleIndex > 10 {
                                                    let visibleIndexReal = visibleIndex - 10
                                                    UserDefaults.standard.set(visibleIndexReal, forKey: "visibleIndex")
                                                } else {
                                                    UserDefaults.standard.set(visibleIndex, forKey: "visibleIndex")
                                                }
                                            }
                                        }
                                    }
                                    return Color.clear
                                }
                            )
                        }
                    }
                    .padding()
                }
                .onAppear {
                    // Recuperar índice guardado y hacer scroll a ese elemento
                    let savedIndex = UserDefaults.standard.integer(forKey: "visibleIndex")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        scrollProxy.scrollTo(savedIndex, anchor: .top)
                    }
                }
            }
        }
    }
}


struct BookItemView: View {
    
    @EnvironmentObject var appState: AppEstado
    @EnvironmentObject var appEstado: AppEstado1
    @Binding var book: Book

    @State private var isVisible = false
    
    var body: some View {
        BookView(book: $book)
            .frame(width: 150, height: 200)
//            .background(Color.gray.opacity(0.8))
            .background(appEstado.temaActual.cardColor.opacity(0.8))
            .cornerRadius(10)
    }
}

struct PlaceholderView: View {
    @EnvironmentObject var appState: AppEstado
    @EnvironmentObject var appEstado: AppEstado1
    @State private var shimmerOffset: CGFloat = -1.0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(appEstado.temaActual.cardColor.opacity(0.2))
                .shadow(radius: 2)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.gray.opacity(0.1),
                            Color.gray.opacity(0.3),
                            Color.gray.opacity(0.1)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .mask(
                    Rectangle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.5), Color.clear]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .rotationEffect(.degrees(20))
                        .offset(x: shimmerOffset * 200)
                )
                .onAppear {
                    startShimmerAnimation()
                }
        }
    }
    
    private func startShimmerAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            shimmerOffset += 0.02
            if shimmerOffset > 2.0 {
                shimmerOffset = -1.0 // Reinicia la animación
            }
        }
    }
}


struct BookView: View {
    @Binding var book: Book  // <-- Binding para poder modificarlo y pasarlo

    @State private var isVisible = false
    
    var body: some View {
        VStack {
            Text(book.title)
                .font(.headline)
                .lineLimit(1)
            Text(book.author)
                .font(.subheadline)
                .lineLimit(1)
            
            HStack {
                Text("\(book.progressInt) %")
                    .font(.subheadline)
                    .lineLimit(1)
                
                ProgressView(value: book.progressFloat)
                   .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                   .frame(width: 100)
            }
            
            NavigationLink(destination: BookReadingView(book: $book)) {
                Text("Leer")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                isVisible = true
            }
        }
        .onDisappear {
            isVisible = false
        }
    }
}

