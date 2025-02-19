
import SwiftUI

struct BorderScribbleRect: View {
    var selected: Bool
    
    var body: some View {
        let elems = [0,1,2]
        let skews: [Double] = [1, 2, -2 ]
        let degrees: [Double] = [1, 0, 179]
        
        ZStack {
            ForEach(elems, id: \.self) { i in
                ApproximateRect(skew: skews[i])
                    .stroke(lineWidth: 2)
                    .foregroundColor(selected ? .blue : MMColors.lines )
                    .rotationEffect( .degrees( degrees[i]) )
            }
        }
    }
}

fileprivate struct ApproximateRect: Shape {
    let skew: Double
    
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        
        let multX1 = (w + skew )
        let multY1 = (h + skew )
        
        let xBegin = 0 + skew
        let yBegin = 0 - skew
        
        var path = Path()
        
        //top line
        path.move(to: CGPoint(x: xBegin, y: yBegin) )
        path.addQuadCurve(
            to: CGPoint(x: xBegin + multX1, y: yBegin + skew ),
            control: CGPoint(x: rect.minX + skew, y: rect.minY)
        )
        
        //bottom line
        path.move(to: CGPoint(x: xBegin + skew, y: yBegin + multY1) )
        path.addQuadCurve(
            to: CGPoint(x: xBegin + multX1, y: yBegin + multY1 ),
            control: CGPoint(x: rect.minX + multX1, y: h + skew )
        )
        
        // left line
        path.move(to: CGPoint(x: xBegin - skew * 2, y: yBegin ) )
        path.addQuadCurve(
            to: CGPoint(x: xBegin + skew, y: yBegin + multY1),
            control: CGPoint(x: rect.minX - skew, y: rect.minY - skew )
        )
        
        //right line
        path.move(to: CGPoint(x: xBegin + multX1, y: yBegin ) )
        path.addQuadCurve(
            to: CGPoint(x: xBegin + multX1 + skew, y: yBegin + multY1),
            control: CGPoint(x: xBegin + multX1 , y: h - skew )
        )
        
        return path
    }
}

/////////////////////
/// Preview
////////////////////
struct BorderScribbleRect_Previews: PreviewProvider {
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
        }
        .padding(150)
        .background(Color.white)
    }
}
