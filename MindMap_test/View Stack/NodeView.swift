
import SwiftUI

struct NodeView: View {
    static let width = CGFloat(100)
    
    @State var node: Node
    
    @ObservedObject var selection: SelectionHandler
    
    var isSelected: Bool {
        return selection.checkIsSelected(node)
    }
    
    var body: some View {
        ZStack {
            SelectedView(isSelected)
                .frame(width: NodeView.width + 12, height: NodeView.width + 12, alignment: .center)
                .overlay { EditNodePanel(isSelected) }
            
            self.node.nodeStyle.shape.asView()
                .fill(Color.yellow)
                .overlay( self.node.nodeStyle.shape.asView().stroke(Color.black, lineWidth: 3) )
                .overlay(
                    Text(node.text)
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                )
                .frame(width: NodeView.width, height: NodeView.width, alignment: .center)
        }
    }
    
    @ViewBuilder
    func SelectedView(_ sel: Bool) -> some View {
        if sel {
            ZStack {
                self.node.nodeStyle.shape.asView()
                    .stroke(Color.blue.opacity(1), lineWidth: 1)
                
                self.node.nodeStyle.shape.asView()
                    .stroke(Color.blue, lineWidth: 2)
                    .blur(radius: 3)
            }
        } else {
            EmptyView()
        }
    }
    
    let offset: CGFloat = 18
    
    @ViewBuilder
    func EditNodePanel(_ sel: Bool) -> some View {
        if sel {
            HStack(spacing: 10) {
                Text.sfSymbol("trash").onTapGesture { self.node.nodeStyle.shape = .circle }
                Text.sfSymbol("trash").onTapGesture { self.node.nodeStyle.shape = .hexagon }
                Text.sfSymbol("trash").onTapGesture { self.node.nodeStyle.shape = .rect }
                Text.sfSymbol("trash").onTapGesture { self.node.nodeStyle.shape = .roundedRect }
                Text.sfSymbol("trash").onTapGesture { self.node.nodeStyle.shape = .capsule }
            }
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill( Color.gray )
            }
            .offset(x: CGFloat((NodeView.width + 12)/2 + offset), y: CGFloat((NodeView.width + 12)/2 + offset) )
        } else {
            EmptyView()
        }
    }
}

/////////////////////
/// Helpers
////////////////////

/////////////////////
/// Preview
////////////////////
struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        let selection1 = SelectionHandler()
        let node1 = Node(text: "hello world", nodeStyle: .sub)
        let selection2 = SelectionHandler()
        let node2 = Node(text: "I'm selected, look at me", nodeStyle: .sub)
        selection2.selectNode(node2)
        
        return VStack {
            NodeView(node: node1, selection: selection1)
            NodeView(node: node2, selection: selection2)
        }
    }
}
