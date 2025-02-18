
import Foundation
import CoreGraphics
import MoreSwiftUI
import SwiftUI

typealias NodeID = UUID

// Color(hex:0x485967)

struct Node: Identifiable {
    var id: NodeID = NodeID()
    var position: CGPoint
    var text: String
    
    var nodeStyle: NodeStyleItem
    
    static var font: Font = Font.system(size: 13)
    
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


