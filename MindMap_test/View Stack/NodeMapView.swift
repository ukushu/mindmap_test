
import SwiftUI

struct NodeMapView: View {
    @ObservedObject var selection: SelectionHandler
    @Binding var nodes: [Node]
    @State var inEdit: Bool = false
    
    var body: some View {
        ZStack {
            Color.clickableAlpha
                .onTapGesture {
                    self.selection.selectClear()
                }
            
            ForEach(nodes, id: \.visualID) { node in
                NodeView(node: node, selection: self.selection)
                    .offset(x: node.position.x, y: node.position.y)
                    .onTapGesture {
                        if NSApp.currentEvent!.modifierFlags.contains(.shift) {
                            self.selection.selectNodeSwitch(node)
                        } else {
                            self.selection.selectNode(node)
                        }
                    }
                    .overlay {
//                        if inEdit {
//                            
//                            TextField("Type the text of new mind…", text: $model.selection.editingText, onCommit: {
//                                if let node = model.selection.onlySelectedNode(in: model.mesh) {
//                                    model.mesh.updateNodeText(node, string: self.model.selection.editingText)
//                                }
//                            })
//                            .textFieldStyle(.roundedBorder)
//                        }
                    }
            }
        }
    }
}

/////////////////////
/// Preview
////////////////////

struct NodeMapView_Previews: PreviewProvider {
    static let node1 = Node(position: CGPoint(x: -100, y: -30), text: "hello")
    static let node2 = Node(position: CGPoint(x: 100, y: 30), text: "world")
    @State static var nodes = [node1, node2]
    
    static var previews: some View {
        let selection = SelectionHandler()
        return NodeMapView(selection: selection, nodes: $nodes)
    }
}
