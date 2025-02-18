
import SwiftUI
import MoreSwiftUI

struct NodeView: View {
    static let width = CGFloat(100)
    
    @State var node: Node
    
    @ObservedObject var selection: SelectionHandler
    
    @State var bgColor: Color = .black
    @State var frColor: Color = .white
    
    var isSelected: Bool {
        return selection.checkIsSelected(node)
    }
    
    var body: some View {
        Text(node.text)
            .font(Node.font)
            .multilineTextAlignment(.center)
            .foregroundStyle(frColor)
            .frame(minHeight: 40)
            .padding( EdgeInsets(horizontal: 20, vertical: 14) )
            .background {
                VStack(spacing: 0) {
                    ZStack {
//                        SelectedView(isSelected)
//                            .padding(12)
                        
                        self.node.nodeStyle.shape.asView()
                            .fill(node.nodeStyle.colorBg)
                            .overlay(
                                self.node.nodeStyle.shape.asScribbleView(isSelected: isSelected)
                            )
                    }
                    
                    EditNodePanel(isSelected)
                        .offset(y: 15)
                        .padding(.bottom, -100)
                }
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
                PopoverButtSimple( label: { Text("[]").fixedSize() } ) {
                    VStack {
                        Button(action: { self.node.nodeStyle.shape = .hexagon }) {
                            NodeShape.hexagon.asView().frame(width: 30, height: 15)
                        }
                        
                        Button(action: { self.node.nodeStyle.shape = .rect }) {
                            NodeShape.rect.asView().frame(width: 30, height: 15)
                        }
                        
                        Button(action: { self.node.nodeStyle.shape = .roundedRect }) {
                            RoundedRectangle(cornerRadius: 4).frame(width: 30, height: 15)
                        }
                        
                        Button(action: { self.node.nodeStyle.shape = .capsule }) {
                            NodeShape.capsule.asView().frame(width: 30, height: 15)
                        }
                    }
                    .padding(13)
                    .buttonStyle(BtnUksStyle.default)
                }
                
                UksColorPicker(color: $bgColor)
                    .frame(width: 15, height: 15)
                    .onChange(of: bgColor) { _, col2 in self.node.nodeStyle.colorBg = col2 }
                
                UksColorPicker(color: $frColor)
                    .frame(width: 15, height: 15)
                    .onChange(of: frColor) { _, col2 in self.node.nodeStyle.colorFr = col2 }
            }
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill( Color.gray )
            }
            .buttonStyle(BtnUksStyle.default)
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
