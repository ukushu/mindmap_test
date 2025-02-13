
import SwiftUI

struct MindMapListView: View {
    @StateObject var model: MindMapListViewModel = MindMapListViewModel()
    
    var body: some View {
        ZStack {
            if let selectedIdx = model.seleted, selectedIdx <= model.mMaps.count {
                MindMapSurfaceView( model: model.mMaps[selectedIdx] )
            } else {
                Text("Create your first MindMap")
            }
            
            TabsPanel()
        }
    }
    
    func TabsPanel() -> some View {
        VStack {
            Spacer()
            
            HStack {
                ForEach(model.mMaps) { item in
                    if let idx = model.mMaps.firstIndex(where: { $0 == item }) {
                        Button(item.mesh.rootNode().text) {
                            model.seleted = idx
                        }
                        .contextMenu{
                            Button("Delete") {
                                model.delete(idx)
                            }
                        }
                    }
                }
                
                Button("+") {
                    model.add()
                }
                
                Spacer()
            }
            .padding(EdgeInsets(top: 4, leading: 5, bottom: 4, trailing: 5))
            .background(Color.gray)
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
