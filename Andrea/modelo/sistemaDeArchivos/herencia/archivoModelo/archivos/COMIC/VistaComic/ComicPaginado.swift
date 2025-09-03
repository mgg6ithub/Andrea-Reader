

import UIKit
import SwiftUI


// MARK: - SinglePage (UIPageViewController integrado en SwiftUI)
struct SinglePage: UIViewControllerRepresentable {
    
    @EnvironmentObject var viewSettings: ViewSettings
    @ObservedObject var sessionCache: ComicCache
    let pages: [String]
    let comicFile: any ProtocoloComic
    @Binding var currentPage: Int

    private var vcCache = ViewControllerCache()
//    private var keyOptions: [UIPageViewController.OptionsKey: Any] = [:]
    private let prefetchRange: Int = 7
    
    init(sessionCache: ComicCache, pages: [String], comicFile: any ProtocoloComic, currentPage: Binding<Int>) {
            
        //VARIABLES DEL CONSTRUCTOR
//        _elementModel = StateObject(wrappedValue: elementModel)
        _sessionCache = ObservedObject(wrappedValue: sessionCache)
        self.pages = pages
        self.comicFile = comicFile
        _currentPage = currentPage

    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        
        //Asignar si esta en modo borde o no al cache de los controladores
        vcCache.setContentMode(isBorderless: viewSettings.isBorderless)
        
        //Estilo de transicion, orientacion y diccionario de opciones del UIPageViewController
        let ts: UIPageViewController.TransitionStyle = viewSettings.curlPageEffect ? .pageCurl : .scroll
        let orientation: UIPageViewController.NavigationOrientation = viewSettings.isVertical ? .vertical : .horizontal
//        print("ACTUALIZANDO ORIENTACION: ", viewSettings.isVertical)
        /**
         Asigna las opciones para el page controller.
            Spine -> Derecha si esta invertido, si no izquierfa. (solo en .pageCurl)
            Padding -> Padding entre paginas (solo en .scroll)
         */
        let keyOptions: [UIPageViewController.OptionsKey: Any] = [
            .spineLocation: viewSettings.isInverted ? UIPageViewController.SpineLocation.max.rawValue : UIPageViewController.SpineLocation.min.rawValue,
            .interPageSpacing: viewSettings.padding
        ]

        //MARK: - Creamos el UIPageViewController con el estilo (.scroll, .pageCurl), la orientacion (.vertical, .horizontal) y las opciones previamente creadas.
        let pageVC = UIPageViewController(transitionStyle: ts, navigationOrientation: orientation, options: keyOptions)
        
        pageVC.dataSource = context.coordinator //La clase Coordinator se encagra de proveer los controladores
        pageVC.delegate = context.coordinator //La clase Coordinator se encarga de los gestos
        
        context.coordinator.pageViewController = pageVC //Asignamos una instancia del UIPageViewController a la clase Coordinator
        
        //MARK: - PRIMER CONTROLADOR
        if let firstVC = context.coordinator.viewController(for: currentPage) {
            pageVC.setViewControllers([firstVC], direction: .forward, animated: true) //Creamos primer controlador
            
            //CARGA EN DIFERIDO DE LAS IMAGENES
            sessionCache.prefetchNearbyPages(currentPage: currentPage, range: prefetchRange) //Prefetching de imagenes.
            //CARGA EN DIFERIDO DE LOS CONTROLLADORES
            vcCache.prefetchNearbyPages(comicFile: comicFile, sessionCache: sessionCache, for: currentPage, prefetchRange: prefetchRange)
        }
        
        //MARK: - DESACTIVAR SLIDER NATIVO
        //Asegurarse de que el tap este activado
        if viewSettings.isSingleTap  && !viewSettings.isDelizar {
            pageVC.view.subviews.forEach { view in
                if let scrollView = view as? UIScrollView {
                    scrollView.isScrollEnabled = viewSettings.isDelizar
                }
            }
        }
        
        //MARK: - ACTIVAR TOQUE UNICO PARA EL DESPLAZAMIENTO
        
        if viewSettings.isSingleTap {
            let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleSingleTap(_:)))
            pageVC.view.addGestureRecognizer(tapGesture)
        }
        
        return pageVC
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        guard let currentVC = pageViewController.viewControllers?.first as? BaseZoomableViewController else { return }
        
        // Si la página actual del binding es diferente de la mostrada
        if currentVC.currentPage != currentPage {
            if let newVC = context.coordinator.viewController(for: currentPage) {
                let direction: UIPageViewController.NavigationDirection = currentPage > currentVC.currentPage ? .forward : .reverse
                pageViewController.setViewControllers([newVC], direction: direction, animated: true)
            }
        }
    }

    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    // MARK: - Coordinator: Maneja la navegación entre páginas
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
        var parent: SinglePage
        var fakeCache: [Int : UIImageView] = [:]
        
        var pageViewController: UIPageViewController?
        
        init(_ parent: SinglePage) {
            self.parent = parent
        }
        
        // Se crea o se recupera el VC para la página indicada.
        func viewController(for page: Int) -> UIViewController? {
            guard isValidIndex(page, totalPages: parent.pages.count) else {
                return nil
            }
            
            if let cachedVC = parent.vcCache.getController(for: page) as? BaseZoomableViewController {
                cachedVC.currentPage = page
                return cachedVC
            }
            
            let zPageVC = parent.viewSettings.isBorderless ? ZoomableViewControllerBorder() : ZoomableViewController()
            zPageVC.currentPage = page
            
            if let image = parent.sessionCache.getImage(for: page) {
                zPageVC.image = image
            } else {
                if let image = parent.comicFile.loadImage(named: parent.comicFile.comicPages[page]) {
                    zPageVC.image = image
                    parent.sessionCache.setImage(image, for: page)
                }
            }
            
            parent.vcCache.setController(zPageVC, for: page)
            return zPageVC
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool
        ) {
            guard completed,
                  let currentVC = pageViewController.viewControllers?.first,
                  let zoomVC = currentVC as? BaseZoomableViewController else { return }
            
            //ASIGNAMOS LA PAGINA ACTUAL
            parent.currentPage = zoomVC.currentPage
            parent.sessionCache.currentPage = zoomVC.currentPage
            parent.comicFile.estadisticas.setCurrentPage(currentPage: zoomVC.currentPage)
            
            //CARGA EN DIFERIDO DE IMAGENES
            parent.sessionCache.prefetchNearbyPages(currentPage: zoomVC.currentPage, range: parent.prefetchRange)
            
            //CARGA EN DIFERIDO DE LOS CONTROLADORES
            parent.vcCache.prefetchNearbyPages(comicFile: parent.comicFile, sessionCache: parent.sessionCache, for: zoomVC.currentPage, prefetchRange: parent.prefetchRange)
            
            // Limpieza de cachés (se mantienen páginas alrededor de la actual)
            parent.sessionCache.cleanupCache(keepingRange: parent.prefetchRange, imageViewCache: &fakeCache)
            parent.vcCache.cleanup(keepingRange: parent.prefetchRange, around: zoomVC.currentPage, totalPages: parent.pages.count)
            
//            print()
//            print("PAGINA ACTUAL", zoomVC.currentPage)
            parent.sessionCache.printCacheInfo()
//            print()
        }
        
        /**
         PAGINA ANTERIOR <-
         */
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
            guard let zoomVC = viewController as? BaseZoomableViewController,
                  zoomVC.currentPage > 0 else { return nil }
            return self.viewController(for: zoomVC.currentPage - 1)
        }
        
        
        /**
         PAGINA SIGUIENTE ->
         */
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController
        ) -> UIViewController? {
            guard let zoomVC = viewController as? BaseZoomableViewController,
                  zoomVC.currentPage < parent.pages.count - 1 else { return nil }
            return self.viewController(for: zoomVC.currentPage + 1)
        }
        
        private func isValidIndex(_ page: Int, totalPages: Int) -> Bool {
            return (0..<totalPages).contains(page)
        }
        
        //MARK: - GESTOS
        
        @objc func handleSingleTap(_ gesture: UITapGestureRecognizer) {
            guard let pageVC = pageViewController,
                  let view = gesture.view else { return }
            
            let tapLocation = gesture.location(in: view)
            
            let isVertical = parent.viewSettings.isVertical
            
            let size = isVertical ? view.bounds.height : view.bounds.width
            let tapCoords = isVertical ? tapLocation.y : tapLocation.x
            
            // Si el tap es mayor que la mitad avanzar
            if tapCoords > size / 2 {
                if parent.currentPage < parent.pages.count - 1 {
                    let newIndex = parent.currentPage + 1
                    parent.currentPage = newIndex
                    parent.sessionCache.currentPage = newIndex
                    parent.comicFile.estadisticas.setCurrentPage(currentPage: newIndex)
                    
                    if let newVC = viewController(for: newIndex) {
                        pageVC.setViewControllers([newVC],
                                                  direction: .forward,
                                                  animated: true,
                                                  completion: nil)
                    }
                }
            }
            // Si está en la mitad izquierda, retroceder página
            else {
                if parent.currentPage > 0 {
                    let newIndex = parent.currentPage - 1
                    parent.currentPage = newIndex
                    
                    if let newVC = viewController(for: newIndex) {
                        pageVC.setViewControllers([newVC],
                                                  direction: .reverse,
                                                  animated: true,
                                                  completion: nil)
                    }
                }
            }
        }
        
        
    }
}

//VIEWCONTROLERRCACHE

extension Notification.Name {
    static let vcDidCache = Notification.Name("vcDidCache") // NOTIFICACIONES DEL CACHE DE CONTROLADORES (NO SE USA)
    static let didCacheImage = Notification.Name("didCacheImage") //CACHE DE IMAGENES
}

class ViewControllerCache {
    
    private var isBorderless: Bool = false
    private let cache = NSCache<NSNumber, UIViewController>()
    private let accessQueue = DispatchQueue(label: "com.vc.cache.access", attributes: .concurrent)
    private var _cachedPages = Set<Int>()
    private var pendingPages = Set<Int>()
    
    public func setContentMode(isBorderless: Bool) {
        self.isBorderless = isBorderless
    }
    
    var cachedPages: Set<Int> {
        get { accessQueue.sync { _cachedPages } }
        set { accessQueue.async(flags: .barrier) { self._cachedPages = newValue } }
    }
    
    func getController(for key: Int) -> UIViewController? {
        accessQueue.sync {
            let keyNumber = NSNumber(value: key)
            return cache.object(forKey: keyNumber)
        }
    }
    
    func setController(_ controller: UIViewController, for key: Int) {
        accessQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            let keyNumber = NSNumber(value: key)
            self.cache.setObject(controller, forKey: keyNumber)
            self._cachedPages.insert(key)
//            print("✅ VC cacheado - Página \(key)")
        }
    }
    
    func cleanup(keepingRange range: Int, around currentPage: Int, totalPages: Int) {
        accessQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            let lowerBound = max(currentPage - range, 0)
            let upperBound = min(currentPage + range, totalPages - 1)
            let pagesToKeep = Set(lowerBound...upperBound)
            let pagesToRemove = self._cachedPages.subtracting(pagesToKeep)
            pagesToRemove.forEach {
                let key = NSNumber(value: $0)
                self.cache.removeObject(forKey: key)
                self._cachedPages.remove($0)
//                print("🗑 VC eliminado - Página \($0)")
            }
        }
    }
    
    //MARK: - PREFETCHING NEARBY PAGES
    
    func prefetchNearbyPages(comicFile: any ProtocoloComic, sessionCache: ComicCache, for page: Int, prefetchRange: Int = 3) {
        
        let nearbyPages = max(page - prefetchRange, 0)...min(page + prefetchRange, comicFile.comicPages.count - 1)
        
        //Prefetch de los controladores
        nearbyPages.forEach { page in
            self.prefetchViewController(for: page, imageCache: sessionCache, comicFile: comicFile, prefetchRange: prefetchRange)
        }
        
    }
    
    
    // MARK: - Prefetching de View Controllers
    // Se añade parámetro prefetchRange para mantener la consistencia con el cache de imágenes
    func prefetchViewController(for page: Int, imageCache: ComicCache, comicFile: any ProtocoloComic, prefetchRange: Int = 3) {
        guard !_cachedPages.contains(page), !pendingPages.contains(page) else { return }
        pendingPages.insert(page)
        
        if let image = imageCache.getImage(for: page) {
            self.createAndCacheVC(page: page, image: image)
            pendingPages.remove(page)
        } else {
            // Declarar el token de observer de forma mutable para poder referenciarlo dentro del closure.
            var token: NSObjectProtocol?
            token = NotificationCenter.default.addObserver(
                forName: .didCacheImage,
                object: nil,
                queue: .main
            ) { [weak self, weak token] notification in
                guard let self = self,
                      let cachedPage = notification.object as? Int,
                      cachedPage == page else { return }

                if let image = imageCache.getImage(for: page) {
                    self.createAndCacheVC(page: page, image: image)
                    NotificationCenter.default.post(name: .vcDidCache, object: page)
                }
                if let token = token {
                    NotificationCenter.default.removeObserver(token)
                }
                self.pendingPages.remove(page)
            }
        }
    }

    
    // Aquí se implementa el "warm-up" del controlador forzando el layout antes de cachearlo.
    private func createAndCacheVC(page: Int, image: UIImage) {
        let zPageVC = isBorderless ? ZoomableViewControllerBorder() : ZoomableViewController()
        zPageVC.image = image
        zPageVC.currentPage = page
        // Warm-up: cargar la vista y forzar el layout
        zPageVC.loadViewIfNeeded() //carga de ante mano el controlador.
        zPageVC.view.setNeedsLayout() //Redibuja cualquier cambio en el controlador.
        zPageVC.view.layoutIfNeeded() //Si se tiene que redibujar que se redibuje ahora.
        self.setController(zPageVC, for: page)
    }
    
    func printCacheInfo() {
        accessQueue.sync {
            _ = _cachedPages.sorted()
        }
    }
}

protocol ZoomableViewControllerProtocol: AnyObject {
    var image: UIImage! { get set }
    var currentPage: Int! { get set }
    var imageView: UIImageView! { get set }
    var scrollView: UIScrollView! { get set }
    
    func updateImageContentMode(for size: CGSize)
    func setupScrollView()
    func addDoubleTapGesture()
}

class BaseZoomableViewController: UIViewController, ZoomableViewControllerProtocol, UIScrollViewDelegate {
    var image: UIImage!
    var currentPage: Int!
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    
    // Implementación común...
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        addDoubleTapGesture()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.updateImageContentMode(for: size)
        })
    }
    
    func setupScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.7
        scrollView.maximumZoomScale = 2.0
        view.addSubview(scrollView)
        
        imageView = UIImageView(image: image)
        
        if image.size.width > image.size.height {
            imageView.contentMode = .scaleAspectFit
        }
        
        imageView.frame = scrollView.bounds
        scrollView.addSubview(imageView)
    }
    
    func updateImageContentMode(for size: CGSize) {
        // Implementación base vacía, será sobreescrita
    }
    
    // Implementaciones comunes de UIScrollViewDelegate y gestos...
    // (Mantener todas las funciones comunes aquí)
    
    func addDoubleTapGesture() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        let newScale = scrollView.zoomScale == 1.0 ? 2.0 : 1.0
        if newScale == 1.0 {
            scrollView.setZoomScale(newScale, animated: true)
        } else {
            let location = sender.location(in: scrollView)
            let zoomRect = zoomRectForScale(scale: newScale, center: location)
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    
    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.width = scrollView.frame.size.width / scale
        zoomRect.size.height = scrollView.frame.size.height / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - imageView.frame.width) / 2, 0)
        let offsetY = max((scrollView.bounds.height - imageView.frame.height) / 2, 0)
        UIView.animate(withDuration: 0.2) {
            scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
        }
    }
}

class ZoomableViewController: BaseZoomableViewController {
    override func updateImageContentMode(for size: CGSize) {
        let viewW = size.width
        let viewH = size.height
        let portratiLanscape = viewW > viewH
        
        if !portratiLanscape && image.size.width < image.size.height {
            imageView.contentMode = .scaleAspectFit
        }
        imageView.frame = CGRect(origin: .zero, size: size)
    }
}

class ZoomableViewControllerBorder: BaseZoomableViewController {
    
    override func setupScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.7
        scrollView.maximumZoomScale = 2.0
        view.addSubview(scrollView)
        
        imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = scrollView.bounds
        
        scrollView.addSubview(imageView)
    }
    
    override func updateImageContentMode(for size: CGSize) {
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(origin: .zero, size: size)
    }
}



