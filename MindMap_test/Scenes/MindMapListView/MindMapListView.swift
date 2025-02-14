
import SwiftUI
import MoreSwiftUI

struct MindMapListView: View {
    @StateObject var model: MindMapListViewModel = MindMapListViewModel()
    
    var body: some View {
        ZStack {
            if let selectedIdx = model.seleted, selectedIdx <= model.mMaps.count {
                MindMapSurfaceView( model: model.mMaps[selectedIdx] )
            } else {
                Text("Create your first MindMap")
                    .fillParent()
            }
            
            TabsPanelView(model: model)
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
