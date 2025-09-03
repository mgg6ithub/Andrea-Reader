
import SwiftUI

struct LectorComic: View {
    
    @Environment(\.dismiss) var dismiss

    var comic: any ProtocoloComic
    
    @Binding var paginaActual: Int

    @State private var currentScale: CGFloat = 1.0
    @State private var isZooming: Bool = false
    @State private var isLocked: Bool = true
    @State private var scrollOffset: CGFloat = 0
    @State private var activePageCurl: Bool = true
    @State private var configVersion: Int = 0
    
    @State private var testCont: Int = 0
    
    @State private var isInitiated: Bool = false
    
    @StateObject var sessionCache: ComicCache
    
    @StateObject var viewSettings = ViewSettings()
    
    init(comic: any ProtocoloComic, paginaActual: Binding<Int>){
        self.comic = comic
        self._paginaActual = paginaActual
        comic.comicPages = comic.cargarPaginas(applyFilters: false)
        
        let sessionCache = ComicCache(comicFile: comic)
        _sessionCache = StateObject(wrappedValue: sessionCache)
    }
    
    var body: some View {
        ZStack {
            //MARK: - PAGINADO (PAGINA A PAGINA)
            SinglePage(
                sessionCache: sessionCache,
                pages: comic.comicPages,
                comicFile: comic,
                currentPage: $paginaActual
            )
            .environmentObject(viewSettings)
            .onDisappear {
                sessionCache.endCache()
            }
            //MARK: - PAGINADO (PAGINA A PAGINA)

        }
        .onAppear {
            comic.leyendose = true
        }
        .ignoresSafeArea()
        .edgesIgnoringSafeArea(.all)
        
    }

}

