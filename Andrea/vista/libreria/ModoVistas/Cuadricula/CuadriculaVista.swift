import SwiftUI

struct CuadriculaVista: View {
    @ObservedObject var vm: ColeccionViewModel

    var body: some View {
        GeometryReader { geo in
            let spacing: CGFloat = 20
            let columnsCount = 6
            let totalSpacing = spacing * CGFloat(columnsCount - 1)
            let itemWidth = (geo.size.width - totalSpacing) / CGFloat(columnsCount)
            let aspectRatio: CGFloat = 310 / 180
            let itemHeight = itemWidth * aspectRatio

            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(
                        columns: Array(
                            repeating: GridItem(.fixed(itemWidth), spacing: spacing),
                            count: columnsCount
                        ),
                        spacing: spacing
                    ) {
                        ForEach(vm.elementos) { elemento in
                            ElementoVista(vm: vm, elemento: elemento) {
                                if let placeholder = elemento as? ElementoPlaceholder {
                                    PlaceholderCuadricula(placeholder: placeholder, width: itemWidth, height: itemHeight)
                                } else if let archivo = elemento as? Archivo {
                                    CuadriculaArchivo(archivo: archivo, coleccionVM: vm, width: itemWidth, height: itemHeight)
                                } else if let coleccion = elemento as? Coleccion {
                                    CuadriculaColeccion(coleccion: coleccion)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
