import SwiftUI

struct Libreria: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    @Namespace private var animationNamespace

    @State private var hasScrolled: Bool = false
    
    @State private var searchText: String = ""
    @FocusState private var searchFieldFocused: Bool
    
    var body: some View {
        
        let visibles = vm.elementosParaMostrar(segun: ap.sistemaArchivos)
        
        var elementosFiltrados: [ElementoSistemaArchivos] {
            guard !searchText.isEmpty else { return visibles }
            return visibles.filter { elemento in
                if let archivo = elemento as? Archivo {
                    return archivo.nombre.localizedCaseInsensitiveContains(searchText)
                } else if let coleccion = elemento as? Coleccion {
                    return coleccion.nombre.localizedCaseInsensitiveContains(searchText)
                } else {
                    return false
                }
            }
        }
        
        VStack(alignment: .center, spacing: 0) {
            
            if ap.barraBusqueda {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField(searchFieldFocused ? "" : "Buscar archivos...", text: $searchText)
                        .focused($searchFieldFocused)
                        .textFieldStyle(PlainTextFieldStyle())
                        .disableAutocorrection(true)
                }
                .padding([.horizontal, .bottom], 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                )
                .padding([.horizontal])
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .padding(.horizontal, 20)
            }
            
            if vm.elementos.isEmpty {
                if vm.coleccion.nombre == "HOME" {
                    ImagenLibreriaVacia(imagen: "estanteria-vacia2", texto: "Biblioteca \"Andrea\" vacía.", anchura: 315, altura: 350)
                } else {
                    ImagenLibreriaVacia(imagen: "caja-vacia", texto: "La colección está vacia.", anchura: 235, altura: 235)
                }
            }
            else {
                switch vm.modoVista {
                case .cuadricula:
                    CuadriculaVista(vm: vm, namespace: animationNamespace, elementos: elementosFiltrados)
                        .transition(.opacity.combined(with: .scale))

                case .lista:
                    ListaVista(vm: vm, namespace: animationNamespace, elementos: visibles)
                        .transition(.opacity.combined(with: .scale))

                default:
                    AnyView(Text("Vista desconocida"))
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: vm.modoVista)
    }
}

struct ImagenLibreriaVacia: View {
    
    @EnvironmentObject var ap: AppEstado
    
    let imagen: String
    let texto: String
    let anchura: CGFloat
    let altura: CGFloat
    
    var scala: CGFloat { ap.constantes.scaleFactor }
    
    @State private var show = false // Para controlar la animación
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            VStack(spacing: 0) {
                Image(imagen)
                    .resizable()
                    .frame(width: anchura * scala, height: altura * scala)
                
                Text(texto)
                    .font(.headline)
                    .foregroundColor(ap.temaResuelto.textColor)
                
            }
            Spacer()
        }
        .aparicionStiffness(show: $show)
    }
}

