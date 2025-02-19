
import SwiftUI

struct FillScribbleRect: View {
    var brushSize: CGFloat = 3
    var color: Color = .green
    var type: ScribbleType = .vertical
    var outer = false
    
    var body: some View {
        ApproximateRect(distance: brushSize * (outer ? 0.6 : 0.5), type: type, outer: outer )
            .stroke(style: StrokeStyle(lineWidth: brushSize, lineCap: .square, lineJoin: .bevel))
            .foregroundColor(color)
    }
}

fileprivate struct ApproximateRect: Shape {
    let distance: Double
    let type: ScribbleType
    let outer: Bool
    
    func path(in rect: CGRect) -> Path {
        switch type {
        case .vertical:
            return vertical(in: rect)
        case .horizontal:
            return horizontal(in: rect)
        }
    }
}

extension ApproximateRect {
    func distCalc(in rect: CGRect) -> ([UInt], [UInt]) {
        var distToBorder: [UInt] = []
        var distBetweenLines: [UInt] = []
        
        var rnd = SeededRandom(seed: Int(distance) )
        var count: Int
        
        switch type {
        case .vertical:
            count = Int(rect.width/distance)
        case .horizontal:
            count = Int(rect.height/distance)
        }
        
        for _ in 1...count {
            distToBorder.append( rnd.next(upperBound: UInt(8) ) )
            distBetweenLines.append( rnd.next(upperBound: UInt(distance) ) )
        }
        
        return (distToBorder, distBetweenLines)
    }
    
    func vertical(in rect: CGRect) -> Path {
        let (distToBorder, distBetweenLines) = distCalc(in: rect)
        
        var path = Path()
        
        //top line
        path.move(to: CGPoint(x: rect.minX, y: rect.minY) )
        
        var flag = true
        for i in distToBorder.indices {
            if flag {
                let t = (outer ? 1 : -1 ) * Double(distToBorder[i])
                
                path.addQuadCurve(
                    to: CGPoint(x: rect.minX + distance * Double(i+2) - Double(distBetweenLines[i]), y: rect.height + t ),
                    control: CGPoint(x: distance * Double(i), y: rect.height/2)
                )
            } else {
                let t = (outer ? -1 : 1 ) * Double(distToBorder[i])
                
                path.addQuadCurve(
                    to: CGPoint(x: rect.minX + distance * Double(i+2) - Double(distBetweenLines[i]), y: rect.minY + t ),
                    control: CGPoint(x: distance * Double(i), y: rect.height/2 )
                )
            }
            flag.toggle()
        }
        
        return path
    }
    
    func horizontal(in rect: CGRect) -> Path {
        let (distToBorder, distBetweenLines) = distCalc(in: rect)
        
        var path = Path()
        
        //top line
        path.move(to: CGPoint(x: rect.minX, y: rect.minY) )
        
        var flag = true
        for i in distToBorder.indices {
            if flag {
                let t = (outer ? 1 : -1 ) * Double(distToBorder[i])
                
                path.addQuadCurve(
                    to: CGPoint(x: rect.width + t, y: rect.minY + distance * Double(i+2) - Double(distBetweenLines[i]) ),
                    control: CGPoint(x: rect.width/2, y: distance * Double(i))
                )
            } else {
                let t = (outer ? -1 : 1 ) * Double(distToBorder[i])
                
                path.addQuadCurve(
                    to: CGPoint(x: rect.minX + t, y: rect.minY + distance * Double(i+2) - Double(distBetweenLines[i]) ),
                    control: CGPoint(x: rect.width/2, y: distance * Double(i) )
                )
            }
            flag.toggle()
        }
        
        return path
    }
}


fileprivate struct SeededRandom: RandomNumberGenerator {
    init(seed: Int) { srand48(seed) }
    func next() -> UInt64 { return UInt64(drand48() * Double(UInt64.max)) }
}

enum ScribbleType {
    case vertical
    case horizontal
//    case diagonal
//    case diagonalReverse
}

/////////////////////
/// Preview
////////////////////
struct FillScribbleRect_Previews: PreviewProvider {
    static var previews: some View {
        let size: CGFloat = 5
        
        return VStack (spacing: 30) {
            ZStack {
                Rectangle()
                    .fill(Color.yellow.opacity(0.2))
                
                FillScribbleRect(brushSize: size, type: .horizontal)
            }
            .frame(width: 50, height: 50)
            
            ZStack {
                Rectangle()
                    .fill(Color.yellow.opacity(0.2))
                
                FillScribbleRect(brushSize: size, type: .horizontal)
            }
            .frame(width: 500, height: 50)
            
            ZStack {
                Rectangle()
                    .fill(Color.yellow.opacity(0.2))
                
                FillScribbleRect(brushSize: size, type: .horizontal)
            }
            .frame(width: 300, height: 300)
        }
        .padding(150)
        .background(Color.white)
    }
}
