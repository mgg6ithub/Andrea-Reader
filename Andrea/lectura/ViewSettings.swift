import SwiftUI

class ViewSettings: ObservableObject {
    
    @Published var previewPages: [UIImage]
    
    //DIMENSIONES
    @Published var isFullscreen: Bool
    @Published var isBorderless: Bool
    @Published var isDimensionPressed: Bool
    @Published var isAutomaticScreenAdjusting: Bool
    @Published var margin: CGFloat
    @Published var padding: CGFloat
    
    //ORIENTACION
    @Published var isVertical: Bool
    @Published var isHorizontal: Bool
    @Published var isInverted: Bool
    
    //PAGINACION
    @Published var isSinglePage: Bool
    @Published var isContiousPage: Bool
    
    //EFECTOS PARA PASAR PAGINAS
    @Published var isSingleTap: Bool
    @Published var isDelizar: Bool
    @Published var curlPageEffect: Bool
    @Published var autoScroll: Bool
    @Published var isMoreEffectsPressed: Bool
    
    //ZOOM
    @Published var isZoom: Bool
    
    //COLORES
    @Published var isColorPressed: Bool
    @Published var selectedBackgroundColor: Color
    
    //OTROS UTILS
    @Published var isAutoScrollActive: Bool
    @Published var scrollSpeed: Double
    @Published var restartTimer: Bool
    @Published var isSliderMove: Bool
    @Published var isZoomOut: Bool
    @Published var isIndividualZoom: Bool
    @Published var isZoomCentered: Bool
    @Published var paddingBetweenPage: CGFloat
    
    init(
        previewPages: [UIImage] = (1...5).compactMap { UIImage(named: "\($0)") },
        isFullscreen: Bool = true,
        isBorderless: Bool = false,
        isDimensionPressed: Bool = false,
        isAutomaticScreenAdjusting: Bool = true,
        margin: CGFloat = 0.0,
        padding: CGFloat = 0.0,
        isVertical: Bool = false,
        isHorizontal: Bool = true,
        isInverted: Bool = false,
        isSinglePage: Bool = false,
        isContiousPage: Bool = true,
        isSingleTap: Bool = false,
        isDelizar: Bool = true,
        curlPageEffect: Bool = false,
        autoScroll: Bool = false,
        isMoreEffectsPressed: Bool = false,
        isZoom: Bool = false,
        isColorPressed: Bool = false,
        selectedBackgroundColor: Color = .black,
        isAutoScrollActive: Bool = false,
        scrollSpeed: Double = 2.0,
        restartTimer: Bool = false,
        isSliderMove: Bool = false,
        isZoomOut: Bool = true,
        isIndividualZoom: Bool = false,
        isZoomCentered: Bool = false,
        paddingBetweenPage: CGFloat = 20
    ) {
//        print("SE CREA VIEWSETTINGS DE NUEVO")
//        print("valor de la orientacion: ", isVertical)
        self.previewPages = previewPages
        self.isFullscreen = isFullscreen
        self.isBorderless = isBorderless
        self.isDimensionPressed = isDimensionPressed
        self.isAutomaticScreenAdjusting = isAutomaticScreenAdjusting
        self.margin = margin
        self.padding = padding
        self.isVertical = isVertical
        self.isHorizontal = isHorizontal
        self.isInverted = isInverted
        self.isSinglePage = isSinglePage
        self.isContiousPage = isContiousPage
        self.isSingleTap = isSingleTap
        self.isDelizar = isDelizar
        self.curlPageEffect = curlPageEffect
        self.autoScroll = autoScroll
        self.isMoreEffectsPressed = isMoreEffectsPressed
        self.isZoom = isZoom
        self.isColorPressed = isColorPressed
        self.selectedBackgroundColor = selectedBackgroundColor
        self.isAutoScrollActive = isAutoScrollActive
        self.scrollSpeed = scrollSpeed
        self.restartTimer = restartTimer
        self.isSliderMove = isSliderMove
        self.isZoomOut = isZoomOut
        self.isIndividualZoom = isIndividualZoom
        self.isZoomCentered = isZoomCentered
        self.paddingBetweenPage = paddingBetweenPage
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "isFullscreen": isFullscreen,
            "isBorderless": isBorderless,
            "isDimensionPressed": isDimensionPressed,
            "isAutomaticScreenAdjusting": isAutomaticScreenAdjusting,
            "margin": margin,
            "padding": padding,
            "isVertical": isVertical,
            "isHorizontal": isHorizontal,
            "isInverted": isInverted,
            "isSinglePage": isSinglePage,
            "isContiousPage": isContiousPage,
            "isSingleTap": isSingleTap,
            "isDelizar": isDelizar,
            "curlPageEffect": curlPageEffect,
            "autoScroll": autoScroll,
            "isMoreEffectsPressed": isMoreEffectsPressed,
            "isZoom": isZoom,
            "isColorPressed": isColorPressed,
            "selectedBackgroundColor": selectedBackgroundColor.toHex() ?? "#000000",
            "isAutoScrollActive": isAutoScrollActive,
            "scrollSpeed": scrollSpeed,
            "restartTimer": restartTimer,
            "isSliderMove": isSliderMove,
            "isZoomOut": isZoomOut,
            "isIndividualZoom": isIndividualZoom,
            "isZoomCentered": isZoomCentered,
            "paddingBetweenPage": paddingBetweenPage
        ]
    }

    
    convenience init(from dictionary: [String: Any]) {
        
//        if let color = dictionary["selectedBackgroundColor"] as? Color  {}
        
        self.init(
            isFullscreen: dictionary["isFullscreen"] as? Bool ?? true,
            isBorderless: dictionary["isBorderless"] as? Bool ?? false,
            isDimensionPressed: dictionary["isDimensionPressed"] as? Bool ?? false,
            isAutomaticScreenAdjusting: dictionary["isAutomaticScreenAdjusting"] as? Bool ?? true,
            margin: dictionary["margin"] as? CGFloat ?? 0.0,
            padding: dictionary["padding"] as? CGFloat ?? 0.0,
            isVertical: dictionary["isVertical"] as? Bool ?? false,
            isHorizontal: dictionary["isHorizontal"] as? Bool ?? true,
            isInverted: dictionary["isInverted"] as? Bool ?? false,
            isSinglePage: dictionary["isSinglePage"] as? Bool ?? true,
            isContiousPage: dictionary["isContiousPage"] as? Bool ?? false,
            isSingleTap: dictionary["isSingleTap"] as? Bool ?? false,
            isDelizar: dictionary["isDelizar"] as? Bool ?? true,
            curlPageEffect: dictionary["curlPageEffect"] as? Bool ?? false,
            autoScroll: dictionary["autoScroll"] as? Bool ?? false,
            isMoreEffectsPressed: dictionary["isMoreEffectsPressed"] as? Bool ?? false,
            isZoom: dictionary["isZoom"] as? Bool ?? false,
            isColorPressed: dictionary["isColorPressed"] as? Bool ?? false,
            selectedBackgroundColor: Color(dictionary["selectedBackgroundColor"] as? Color ?? .black),
            isAutoScrollActive: dictionary["isAutoScrollActive"] as? Bool ?? false,
            scrollSpeed: dictionary["scrollSpeed"] as? Double ?? 2.0,
            restartTimer: dictionary["restartTimer"] as? Bool ?? false,
            isSliderMove: dictionary["isSliderMove"] as? Bool ?? false,
            isZoomOut: dictionary["isZoomOut"] as? Bool ?? true,
            isIndividualZoom: dictionary["isIndividualZoom"] as? Bool ?? false,
            isZoomCentered: dictionary["isZoomCentered"] as? Bool ?? false,
            paddingBetweenPage: dictionary["paddingBetweenPage"] as? CGFloat ?? 20
        )
    }
    
    func resetParentSettings(_ dictionary: [String: Any]) {
        if let isFullscreen = dictionary["isFullscreen"] as? Bool {
            self.isFullscreen = isFullscreen
        }
        if let isBorderless = dictionary["isBorderless"] as? Bool {
            self.isBorderless = isBorderless
        }
        if let isDimensionPressed = dictionary["isDimensionPressed"] as? Bool {
            self.isDimensionPressed = isDimensionPressed
        }
        if let isAutomaticScreenAdjusting = dictionary["isAutomaticScreenAdjusting"] as? Bool {
            self.isAutomaticScreenAdjusting = isAutomaticScreenAdjusting
        }
        if let margin = dictionary["margin"] as? CGFloat {
            self.margin = margin
        }
        if let padding = dictionary["padding"] as? CGFloat {
            self.padding = padding
        }
        if let isVertical = dictionary["isVertical"] as? Bool {
            self.isVertical = isVertical
        }
        if let isHorizontal = dictionary["isHorizontal"] as? Bool {
            self.isHorizontal = isHorizontal
        }
        if let isInverted = dictionary["isInverted"] as? Bool {
            self.isInverted = isInverted
        }
        if let isSinglePage = dictionary["isSinglePage"] as? Bool {
            self.isSinglePage = isSinglePage
        }
        if let isContiousPage = dictionary["isContiousPage"] as? Bool {
            self.isContiousPage = isContiousPage
        }
        if let isSingleTap = dictionary["isSingleTap"] as? Bool {
            self.isSingleTap = isSingleTap
        }
        if let isDelizar = dictionary["isDelizar"] as? Bool {
            self.isDelizar = isDelizar
        }
        if let curlPageEffect = dictionary["curlPageEffect"] as? Bool {
            self.curlPageEffect = curlPageEffect
        }
        if let autoScroll = dictionary["autoScroll"] as? Bool {
            self.autoScroll = autoScroll
        }
        if let isMoreEffectsPressed = dictionary["isMoreEffectsPressed"] as? Bool {
            self.isMoreEffectsPressed = isMoreEffectsPressed
        }
        if let isZoom = dictionary["isZoom"] as? Bool {
            self.isZoom = isZoom
        }
        if let isColorPressed = dictionary["isColorPressed"] as? Bool {
            self.isColorPressed = isColorPressed
        }
        if let selectedBackgroundColorHex = dictionary["selectedBackgroundColor"] as? Color {
            self.selectedBackgroundColor = Color(selectedBackgroundColorHex)
        }
        if let isAutoScrollActive = dictionary["isAutoScrollActive"] as? Bool {
            self.isAutoScrollActive = isAutoScrollActive
        }
        if let scrollSpeed = dictionary["scrollSpeed"] as? Double {
            self.scrollSpeed = scrollSpeed
        }
        if let restartTimer = dictionary["restartTimer"] as? Bool {
            self.restartTimer = restartTimer
        }
        if let isSliderMove = dictionary["isSliderMove"] as? Bool {
            self.isSliderMove = isSliderMove
        }
        if let isZoomOut = dictionary["isZoomOut"] as? Bool {
            self.isZoomOut = isZoomOut
        }
        if let isIndividualZoom = dictionary["isIndividualZoom"] as? Bool {
            self.isIndividualZoom = isIndividualZoom
        }
        if let isZoomCentered = dictionary["isZoomCentered"] as? Bool {
            self.isZoomCentered = isZoomCentered
        }
        if let paddingBetweenPage = dictionary["paddingBetweenPage"] as? CGFloat {
            self.paddingBetweenPage = paddingBetweenPage
        }
    }


    
    public func changeColor(color: Color) {
        self.selectedBackgroundColor = color
    }
}

