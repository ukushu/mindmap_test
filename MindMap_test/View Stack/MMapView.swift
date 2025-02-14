
import SwiftUI

struct MMapView: View {
    @ObservedObject var selection: SelectionHandler
    @ObservedObject var mesh: Mesh
    
    var body: some View {
        ZStack {
            EdgeMapView(edges: $mesh.links)
            NodeMapView(selection: selection, nodes: $mesh.nodes)
        }
    }
}

/////////////////////
/// Preview
////////////////////

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let mesh = Mesh()
        let child1 = Node(position: CGPoint(x: 100, y: 200), text: "child 1")
        let child2 = Node(position: CGPoint(x: -100, y: 200), text: "child 2")
        [child1, child2].forEach {
            mesh.addNode($0)
            mesh.connect(mesh.rootNode(), to: $0)
        }
        mesh.connect(child1, to: child2)
        let selection = SelectionHandler()
        return MMapView(selection: selection, mesh: mesh)
    }
}
