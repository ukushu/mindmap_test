
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

struct CircleScribbled: View {
    var selected: Bool
    @State var skew: Double = [0.04, 0.03, 0.02, 0.01, -0.01, -0.02, -0.03, -0.04].randomElement()!
    
    struct ApproximateCircle: Shape {
        let skew: Double
        
        func path(in rect: CGRect) -> Path {
            let w = rect.width
            let h = rect.height
            let xBegin = rect.minX + (w * skew)
            let yBegin = rect.midY + (h * skew)
            var path = Path()
            path.move(to: CGPoint(x: xBegin, y: yBegin))
            path.addQuadCurve(
                to: CGPoint(x: rect.midX + (w * skew), y: rect.minY + (h * skew)),
                control: CGPoint(x: rect.minX + ((w / 2) * skew), y: rect.minY + ((h / 2) * skew))
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX + (w * skew), y: rect.midY + (h * skew)),
                control: CGPoint(x: rect.maxX + ((w / 2) * skew), y: rect.minY + ((h / 2) * skew))
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.midX + (w * skew), y: rect.maxY + (h * skew)),
                control: CGPoint(x: rect.maxX + ((w / 2) * skew), y: rect.maxY + ((h / 2) * skew))
            )
            path.addQuadCurve(
                to: CGPoint(x: xBegin, y: yBegin),
                control: CGPoint(x: rect.minX + ((w / 2) * skew), y: rect.maxY + ((h / 2) * skew))
            )
            path.closeSubpath()
            return path
        }
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                ApproximateCircle(skew: skew)
                    .stroke(lineWidth: 2)
                    .foregroundColor(selected ? .blue : .black)
                    .rotationEffect(.degrees(Double(i) * 15))
            }
        }
        
    }
}

/////////////////////
/// Preview
////////////////////
struct Shapes_Previews: PreviewProvider {
    static var previews: some View {
        return VStack {
            ZStack {
                Rectangle()
                    .fill(Color.yellow)
                
                BorderScribbleRect(selected: false)
            }
            .frame(width: 50, height: 50)
            
            ZStack {
                Rectangle()
                    .fill(Color.yellow)
                
                BorderScribbleRect(selected: false)
            }
            .frame(width: 500, height: 50)
            
            ZStack {
                Rectangle()
                    .fill(Color.yellow)
                
                BorderScribbleRect(selected: false)
            }
            .frame(width: 300, height: 300)
//            HexagonShape()
//                .frame(width: 300)
//            
//            GearShape(teeth: 8, innerRadiusSize: 0.8)
        }
        .padding(150)
        .background(Color.white)
    }
}
