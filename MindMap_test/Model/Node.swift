
import Foundation
import CoreGraphics

typealias NodeID = UUID

struct Node: Identifiable {
    var id: NodeID = NodeID()
    var position: CGPoint
    var text: String
    
    var nodeStyle: NodeStyleItem
    
    init(position: CGPoint = .zero, text: String = "", nodeStyle: NodeStyle) {
        self.position = position
        self.text = text
        self.nodeStyle = nodeStyle.style
    }
    
    var visualID: String {
        return id.uuidString
        + "\(text.hashValue)"
    }
}

extension Node {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
}


