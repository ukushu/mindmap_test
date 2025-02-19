
import SwiftUI

struct FillScribbleRect: View {
    var brushSize: CGFloat = 3
    var color: Color = .green
    
    var body: some View {
        ApproximateRect(distance: brushSize)
            .stroke(style: StrokeStyle(lineWidth: brushSize, lineCap: .round, lineJoin: .round))
            .foregroundColor(color)
    }
}

fileprivate struct ApproximateRect: Shape {
    let distance: Double
    
    func path(in rect: CGRect) -> Path {
        var outLinesDist: [UInt] = []
        var distBetweenLines: [UInt] = []
        
        var rnd = SeededRandom(seed: Int(distance) )
        let count = Int(rect.width/distance)
        for _ in 1...count {
            outLinesDist.append( rnd.next(upperBound: UInt(15) ) )
            distBetweenLines.append( rnd.next(upperBound: UInt(distance) ) )
        }
        
        var path = Path()
        
        //top line
        path.move(to: CGPoint(x: rect.minX, y: rect.minY) )
        
        var flag = true
        for i in outLinesDist.indices {
            if flag {
                path.addQuadCurve(
                    to: CGPoint(x: rect.minX + distance * Double(i) - Double(distBetweenLines[i]), y: rect.height + Double(outLinesDist[i]) ),
                    control: CGPoint(x: distance * Double(i), y: rect.height/2)
                )
            } else {
                path.addQuadCurve(
                    to: CGPoint(x: rect.minX + distance * Double(i) - Double(distBetweenLines[i]), y: rect.minY - Double(outLinesDist[i]) ),
                    control: CGPoint(x: distance * Double(i), y: rect.height/2 )
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
                
                FillScribbleRect(brushSize: size)
            }
            .frame(width: 50, height: 50)
            
            ZStack {
                Rectangle()
                    .fill(Color.yellow.opacity(0.2))
                
                FillScribbleRect(brushSize: size)
            }
            .frame(width: 500, height: 50)
            
            ZStack {
                Rectangle()
                    .fill(Color.yellow.opacity(0.2))
                
                FillScribbleRect(brushSize: size)
            }
            .frame(width: 300, height: 300)
        }
        .padding(150)
        .background(Color.white)
    }
}
