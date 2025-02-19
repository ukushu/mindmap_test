import SwiftUI
import MoreSwiftUI

enum NodeStyle {
    case root
    case sub
}

enum NodeShape {
    case roundedRect
    case hexagon
    case capsule
    case rect
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
    var shape: NodeShape
    var colorBg: Color = .yellow
    var colorFr: Color = .black
}

extension NodeShape {
    func asView() -> AnyShape  {
        switch self {
        case .roundedRect:
            AnyShape( RoundedRectangle(cornerRadius: 25) )
        case .hexagon:
            AnyShape( HexagonShape() )
        case .rect:
            AnyShape( Rectangle() )
        case .capsule:
            AnyShape( Capsule() )
        }
    }
    
    @ViewBuilder
    func asScribbleView(isSelected: Bool) -> some View {
        switch self {
        case .roundedRect:
            BorderScribbleRect(selected: isSelected)
        case .hexagon:
            BorderScribbleRect(selected: isSelected)
        case .rect:
            BorderScribbleRect(selected: isSelected)
        case .capsule:
            CircleScribbled(selected: isSelected)
        }
    }
}
