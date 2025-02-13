
import SwiftUI

struct MindMapListView: View {
    @StateObject var list: MindMapListViewModel = .init()
    
    var body: some View {
        NavigationView {
            VStack {
                TopMenu
                
                List(list.files) { item in
                    NavigationLink(item.mesh.rootNode().text) {
                        MindMapSurfaceView(mesh: item.mesh, selection: item.selection)
                            .navigationTitle( Text( "Mindmap: \( item.mesh.rootNode().text )" ) )
                    }
                }
            }
            .padding(.vertical, 50)
        }
        .navigationTitle("Mindmaps Browser")
        .navigationViewStyle(.stack)
        .navigationBarItems(trailing: TopMenu)
    }
    
    var TopMenu: some View {
        Button("Add MindMap") {
            list.addNote()
        }
    }
}

/////////////////////
/// Preview
////////////////////

struct FilesListView_Previews: PreviewProvider {
    static var previews: some View {
        MindMapListView()
    }
}
