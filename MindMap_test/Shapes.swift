
import SwiftUI

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width * 0.5, y: 0))
        path.addLine(to: CGPoint(x: width, y: height * 0.25))
        path.addLine(to: CGPoint(x: width, y: height * 0.75))
        path.addLine(to: CGPoint(x: width * 0.5, y: height))
        path.addLine(to: CGPoint(x: 0, y: height * 0.75))
        path.addLine(to: CGPoint(x: 0, y: height * 0.25))
        path.closeSubpath()
        
        return path
    }
}


struct GearShape: Shape {
    var teeth: Int = 8
    var innerRadiusSize: CGFloat = 0.75
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * innerRadiusSize
        let toothWidth = CGFloat.pi * 2 / CGFloat(teeth * 2)
        
        for i in 0..<(teeth * 2) {
            let angle = toothWidth * CGFloat(i)
            let radius = (i % 2 == 0) ? outerRadius : innerRadius
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        path.closeSubpath()
        return path
    }
}

/////////////////////
/// Preview
////////////////////
struct Shapes_Previews: PreviewProvider {
    static var previews: some View {
        return VStack {
            HexagonShape()
                .frame(width: 300)
            
            GearShape(teeth: 8, innerRadiusSize: 0.8)
        }
    }
}
