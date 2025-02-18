
import SwiftUI
import Essentials

struct NodeMapView: View {
    @ObservedObject var selection: SelectionHandler
    @Binding var nodes: [Node]
    @State var inEdit: UUID?
    
    @State var text = ""
    
    var body: some View {
        ZStack {
            Color.clickableAlpha
                .onTapGesture {
                    self.selection.selectClear()
                    if self.inEdit != nil {
                        self.inEdit = nil
                    }
                }
            
            ForEach(nodes, id: \.visualID) { node in
                NodeView(node: node, selection: self.selection)
                    .backgroundStyle(Color.clickableAlpha)
                    .overlay { EditView(node: node) }
                    .offset(x: node.position.x, y: node.position.y)
                    .gesture(
                        TapGesture(count: 2).onEnded {
                            text = node.text
                            inEdit = node.id
                        })
                        .simultaneousGesture(TapGesture().onEnded {
                            if self.inEdit != nil {
                                self.inEdit = nil
                            }
                            
                            if NSApp.currentEvent!.modifierFlags.check(oneOf: [.shift, .command]) {
                                self.selection.selectNodeSwitch(node)
                            } else {
                                self.selection.selectNode(node)
                            }
                        }
                    )
            }
        }
    }
    
    @ViewBuilder
    func EditView(node: Node) -> some View {
        if inEdit == node.id {
            if let id = nodes.firstIndex(where: { $0.id == node.id }) {
                TextField(nodes[id].text, text: $text, onCommit: {
                    nodes[id].text = text
                    inEdit = nil
                })
                .textFieldStyle(.roundedBorder)
                .frame(minWidth: 300)
                .padding(5)
                .background(Color.black)
            }
        }
    }
    
}

/////////////////////
/// Preview
////////////////////

struct NodeMapView_Previews: PreviewProvider {
    static let node1 = Node(position: CGPoint(x: -100, y: -30), text: "hello", nodeStyle: .root)
    static let node2 = Node(position: CGPoint(x: 100, y: 30), text: "world", nodeStyle: .sub)
    @State static var nodes = [node1, node2]
    
    static var previews: some View {
        let selection = SelectionHandler()
        return NodeMapView(selection: selection, nodes: $nodes)
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
            get { .none }
            set { }
    }
}
