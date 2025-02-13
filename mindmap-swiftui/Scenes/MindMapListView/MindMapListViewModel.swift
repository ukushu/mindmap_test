
import SwiftUI

class MindMapListViewModel: ObservableObject {
    @Published var files: [File] = [
        File.init(mesh: Mesh.sampleMesh(), selection: SelectionHandler.init())
    ]
    
    func addNote() {
        files.append(File.init(mesh: Mesh.sampleMesh(), selection: SelectionHandler.init()))
    }
}

class File: Identifiable {
    @Published var mesh: Mesh
    @Published var selection: SelectionHandler
    
    init(mesh: Mesh = .sampleMesh(), selection: SelectionHandler = .init()) {
        self.mesh = mesh
        self.selection = selection
    }
    
    var id: String {
        mesh.rootNodeID.uuidString
    }
}
