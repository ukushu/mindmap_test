
import Foundation
import CoreGraphics
import SwiftUI

struct DragInfo {
    var id: NodeID
    var originalPosition: CGPoint
}

class SelectionHandler: ObservableObject {
    @Published var draggingNodes: [DragInfo] = []
    @Published private(set) var selectedNodeIDs: [NodeID] = []
    
    @Published var editingText: String = ""
    
    func selectClear() {
        selectedNodeIDs = []
        editingText = ""
    }
    
    func selectNode(_ node: Node) {
        selectedNodeIDs = [node.id]
        editingText = node.text
    }
    
    func selectNodeSwitch(_ node: Node) {
        if let idx = selectedNodeIDs.firstIndex(of: node.id) {
            selectedNodeIDs.remove(at: idx)
        } else {
            selectedNodeIDs.append(node.id)
        }
    }
    
    func checkIsSelected(_ node: Node) -> Bool {
        return selectedNodeIDs.contains(node.id)
    }
    
    func selectedNodes(in mesh: Mesh) -> [Node] {
        return selectedNodeIDs.compactMap { mesh.nodeWithID($0) }
    }
    
    func onlySelectedNode(in mesh: Mesh) -> Node? {
        let selectedNodes = self.selectedNodes(in: mesh)
        if selectedNodes.count == 1 {
            return selectedNodes.first
        }
        return nil
    }
    
    func startDragging(_ mesh: Mesh) {
        draggingNodes = selectedNodes(in: mesh)
            .map { DragInfo(id: $0.id, originalPosition: $0.position) }
    }
    
    func stopDragging(_ mesh: Mesh) {
        draggingNodes = []
    }
}
