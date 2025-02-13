
import SwiftUI


struct MindMapSurfaceView: View {
    @ObservedObject var model: MindMapItem
    
    //dragging
    @State var portalPosition: CGPoint = .zero
    @State var dragOffset: CGSize = .zero
    @State var isDragging: Bool = false
    @State var isDraggingMesh: Bool = false
    
    //zooming
    @State var zoomScale: CGFloat = 1.0
    @State var initialZoomScale: CGFloat?
    @State var initialPortalPosition: CGPoint?
    
    var body: some View {
        VStack {
            TopMenu()
            
            Container()
        }
    }
    
    func TopMenu() -> some View {
        HStack {
            Button("Add node") {
                model.mesh.addNode(Node.init(id: NodeID.init(uuidString: UUID().uuidString)!, position: CGPoint.init(x: 20, y: 40), text: "Bla"))
            }
        }
    }
    
    func Container() -> some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle().fill(Color.red)
                
                MapView(selection: model.selection, mesh: model.mesh)
                    .scaleEffect(self.zoomScale)
                    .offset(
                        x: self.portalPosition.x + self.dragOffset.width,
                        y: self.portalPosition.y + self.dragOffset.height)
                    .animation(.easeIn, value: portalPosition)
            }
            .gesture( myDragGesture(geometry: geometry) )
            .gesture( myNagnificationGesture(geometry: geometry) )
        }
    }
}

/////////////////
///Gestures
/////////////////

fileprivate extension MindMapSurfaceView {
    func myDragGesture(geometry: GeometryProxy) -> _EndedGesture<_ChangedGesture<DragGesture>> {
        DragGesture()
            .onChanged { value in
                self.processDragChange(value, containerSize: geometry.size)
            }
            .onEnded { value in
                self.processDragEnd(value)
            }
    }
    
    func myNagnificationGesture(geometry: GeometryProxy) -> _EndedGesture<_ChangedGesture<MagnificationGesture>> {
        MagnificationGesture()
            .onChanged { value in
                if self.initialZoomScale == nil {
                    self.initialZoomScale = self.zoomScale
                    self.initialPortalPosition = self.portalPosition
                }
                self.processScaleChange(value)
            }
            .onEnded { value in
                self.processScaleChange(value)
                self.initialZoomScale = nil
                self.initialPortalPosition  = nil
            }
    }
}


/////////////////
///HELPERS
/////////////////
///
private extension MindMapSurfaceView {
    func distance(from pointA: CGPoint, to pointB: CGPoint) -> CGFloat {
        let xdelta = pow(pointA.x - pointB.x, 2)
        let ydelta = pow(pointA.y - pointB.y, 2)
        
        return sqrt(xdelta + ydelta)
    }
    
    func hitTest(point: CGPoint, parent: CGSize) -> Node? {
        for node in model.mesh.nodes {
            let endPoint = node.position
                .scaledFrom(zoomScale)
                .alignCenterInParent(parent)
                .translatedBy(x: portalPosition.x, y: portalPosition.y)
            let dist =  distance(from: point, to: endPoint) / zoomScale
            
            if dist < NodeView.width / 2.0 {
                return node
            }
        }
        
        return nil
    }
    
    func processNodeTranslation(_ translation: CGSize) {
        guard !model.selection.draggingNodes.isEmpty else { return }
        
        let scaledTranslation = translation.scaledDownTo(zoomScale)
        
        model.mesh.processNodeTranslation( scaledTranslation, nodes: model.selection.draggingNodes)
    }
    
    func processDragChange(_ value: DragGesture.Value, containerSize: CGSize) {
        if !isDragging {
            isDragging = true
            
            if let node = hitTest(point: value.startLocation, parent: containerSize) {
                isDraggingMesh = false
                
                if model.selection.selectedNodeIDs.contains(node.id) {
                    
                } else {
                    model.selection.selectNode(node)
                }
                
                model.selection.startDragging(model.mesh)
            } else {
                isDraggingMesh = true
            }
        }
        
        if isDraggingMesh {
            dragOffset = value.translation
        } else {
            processNodeTranslation(value.translation)
        }
    }
    
    func processDragEnd(_ value: DragGesture.Value) {
        isDragging = false
        dragOffset = .zero
        
        if isDraggingMesh {
            portalPosition = CGPoint( x: portalPosition.x + value.translation.width, y: portalPosition.y + value.translation.height )
        } else {
            processNodeTranslation(value.translation)
            model.selection.stopDragging(model.mesh)
        }
    }
    
    func scaledOffset(_ scale: CGFloat, initialValue: CGPoint) -> CGPoint {
        let newx = initialValue.x*scale
        let newy = initialValue.y*scale
        return CGPoint(x: newx, y: newy)
    }
    
    func clampedScale(_ scale: CGFloat, initialValue: CGFloat?) -> (scale: CGFloat, didClamp: Bool) {
        let minScale: CGFloat = 0.1
        let maxScale: CGFloat = 2.0
        let raw = scale.magnitude * (initialValue ?? maxScale)
        let value =  max(minScale, min(maxScale, raw))
        let didClamp = raw != value
        return (value, didClamp)
    }
    
    func processScaleChange(_ value: CGFloat) {
        let clamped = clampedScale(value, initialValue: initialZoomScale)
        zoomScale = clamped.scale
        if !clamped.didClamp,
           let point = initialPortalPosition {
            portalPosition = scaledOffset(value, initialValue: point)
        }
    }
}

/////////////////////
/// Preview
////////////////////

struct SurfaceView_Previews: PreviewProvider {
    static var previews: some View {
        let model = MindMapItem(mesh: Mesh.sampleMesh(), selection: SelectionHandler())
        
        return MindMapSurfaceView(model: model)
    }
}
