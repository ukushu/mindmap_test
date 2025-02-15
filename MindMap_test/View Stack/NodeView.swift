
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
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.yellow)
                .overlay( RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 3) )
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
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.blue.opacity(1), lineWidth: 1)
                
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.blue, lineWidth: 2)
                    .blur(radius: 3)
            }
        } else {
            EmptyView()
        }
    }
    
    let offset: CGFloat = 30
    
    @ViewBuilder
    func EditNodePanel(_ sel: Bool) -> some View {
        if sel {
            HStack(spacing: 10) {
                Text.sfSymbol("trash")
                Text.sfSymbol("trash")
                Text.sfSymbol("trash")
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
        let node1 = Node(text: "hello world")
        let selection2 = SelectionHandler()
        let node2 = Node(text: "I'm selected, look at me")
        selection2.selectNode(node2)
        
        return VStack {
            NodeView(node: node1, selection: selection1)
            NodeView(node: node2, selection: selection2)
        }
    }
}
