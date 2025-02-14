
import SwiftUI

class MMEditorViewModel: ObservableObject {
    @Published var mMaps: [MindMapItem] = [
        MindMapItem.init(mesh: Mesh.sampleMesh(), selection: SelectionHandler.init())
    ]
    
    @Published var seleted: Int? = 0 // = nil
    
    func add() {
        mMaps.append( MindMapItem(mesh: Mesh.sampleMesh(), selection: SelectionHandler(), name: "Target \(mMaps.count + 1)") )
        
        if seleted == nil {
            seleted = 0
        }
    }
    
    func delete(_ idx: Int) {
        guard idx >= 0 else { return }
        
        if mMaps.count == 1 {
            seleted = nil
            mMaps.remove(at: 0)
        } else if idx < mMaps.count, idx - 1 >= 0 {
            seleted = idx - 1
            mMaps.remove(at: idx)
        }
    }
    
    func duplicate(_ idx: Int) {
        mMaps.insert( MindMapItem(mMaps[idx]) , at: idx+1)
    }
}

class MindMapItem: ObservableObject, Identifiable, Equatable {
    @Published var mesh: Mesh
    @Published var selection: SelectionHandler
    @Published var name: String
    
    var id: String { mesh.rootNodeID.uuidString }
    
    init(mesh: Mesh = .sampleMesh(), selection: SelectionHandler = .init(), name: String = "Mind Map 1") {
        self.mesh = mesh
        self.selection = selection
        self.name = name
    }
    
    init(_ item: MindMapItem) {
        self.mesh = item.mesh.copiedInstance()
        self.selection = SelectionHandler()
        self.name = item.name
    }
    
    static func == (lhs: MindMapItem, rhs: MindMapItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func addNode(_ text: String) {
        mesh.addNode(Node.init(id: NodeID(), position: CGPoint.init(x: 20, y: 40), text: text))
    }
    
    func removeSelectedNodes() {
        selection.selectedNodeIDs.forEach{ item in
            mesh.nodes.removeFirst(where: { $0.id == item })
        }
        
        selection.selectClear()
        
        mesh.rebuildLinks()
    }
}
