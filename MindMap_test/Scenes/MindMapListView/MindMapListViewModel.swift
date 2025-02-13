
import SwiftUI

class MindMapListViewModel: ObservableObject {
    @Published var mMaps: [MindMapItem] = [
        MindMapItem.init(mesh: Mesh.sampleMesh(), selection: SelectionHandler.init())
    ]
    
    @Published var seleted: Int? = 0 // = nil
    
    func add() {
        mMaps.append(MindMapItem.init(mesh: Mesh.sampleMesh(), selection: SelectionHandler.init()))
        
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
}

class MindMapItem: ObservableObject, Identifiable, Equatable {
    @Published var mesh: Mesh
    @Published var selection: SelectionHandler
    
    var id: String { mesh.rootNodeID.uuidString }
    
    init(mesh: Mesh = .sampleMesh(), selection: SelectionHandler = .init()) {
        self.mesh = mesh
        self.selection = selection
    }
    
    static func == (lhs: MindMapItem, rhs: MindMapItem) -> Bool {
        lhs.id == rhs.id
    }
}
