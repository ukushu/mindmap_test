import SwiftUI
import MoreSwiftUI

enum NodeStyle {
    case root
    case sub
}

extension NodeStyle {
    var style: NodeStyleItem {
        switch self {
        case .root:
            NodeStyleItem(shape: .roundedRect)
        case .sub:
            NodeStyleItem(shape: .hexagon)
        }
    }
}

struct NodeStyleItem {
    var shape: MMShape
    var colorBg: Color = .yellow
    var colorFr: Color = .black
}

enum MMShape {
    case roundedRect
    case hexagon
    case circle
    case capsule
    case rect
}

extension MMShape {
    func asView() -> AnyShape  {
        switch self {
        case .roundedRect:
            AnyShape( RoundedRectangle(cornerRadius: 25) )
        case .hexagon:
            AnyShape( HexagonShape() )
        case .circle:
            AnyShape( Circle() )
        case .rect:
            AnyShape( Rectangle() )
        case .capsule:
            AnyShape( Capsule() )
        }
    }
}
