
import SwiftUI

class MMEditorViewModel: ObservableObject {
    @Published var mMaps: [MindMapFile]
    
    @Published var selected: MindMapFile? // = nil
    var selectedIdx: Int? {
        guard let selected else { return nil }
        return mMaps.firstIndex(of: selected)
    }
    
    init() {
        self.mMaps = [MindMapFile.init(mesh: Mesh.sampleMesh(), selection: SelectionHandler.init())]
        self.selected = mMaps.first
    }
    
    func add() {
        mMaps.append( MindMapFile(mesh: Mesh.sampleMesh(), selection: SelectionHandler(), name: "Target \(mMaps.count + 1)") )
        
        if selected == nil {
            selected = mMaps.first
        }
    }
    
    func delete(_ idx: Int) {
        guard idx >= 0 else { return }
        
        if mMaps.count == 1 {
            selected = nil
        } else if idx < mMaps.count, idx - 1 >= 0 {
            if idx == selectedIdx {
                if idx > 0 {
                    self.selected = mMaps[selectedIdx! - 1]
                }
            }
        }
            
        mMaps.remove(at: idx)
    }
    
    func duplicate(_ idx: Int) {
        mMaps.insert( MindMapFile(mMaps[idx]) , at: idx+1)
    }
}

class MindMapFile: ObservableObject, Identifiable, Equatable {
    @Published var mesh: Mesh
    @Published var selection: SelectionHandler
    @Published var name: String
    
    var id: String { mesh.rootNodeID.uuidString }
    
    init(mesh: Mesh = .sampleMesh(), selection: SelectionHandler = .init(), name: String = "Mind Map 1") {
        self.mesh = mesh
        self.selection = selection
        self.name = name
    }
    
    init(_ item: MindMapFile) {
        self.mesh = item.mesh.copiedInstance()
        self.selection = SelectionHandler()
        self.name = item.name
    }
    
    static func == (lhs: MindMapFile, rhs: MindMapFile) -> Bool {
        lhs.id == rhs.id
    }
    
    func addNode(_ text: String) {
        mesh.addNode(Node.init(position: CGPoint.init(x: 20, y: 40), text: text, nodeStyle: .sub))
    }
    
    func removeSelectedNodes() {
        selection.selectedNodeIDs.forEach{ item in
            mesh.nodes.removeFirst(where: { $0.id == item })
        }
        
        selection.selectClear()
        
        mesh.rebuildLinks()
    }
}
