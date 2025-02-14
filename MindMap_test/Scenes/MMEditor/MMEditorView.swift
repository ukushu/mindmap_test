
import SwiftUI
import MoreSwiftUI

struct MMEditorView: View {
    @StateObject var model: MMEditorViewModel = MMEditorViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            EditorCanvas()
            
            TabsPanelView(model: model)
        }
    }
    
    @ViewBuilder
    func EditorCanvas() -> some View {
        if let selectedIdx = model.seleted, selectedIdx <= model.mMaps.count {
            MindMapSurfaceView( model: model.mMaps[selectedIdx] )
        } else {
            Text("Create your first MindMap using button\nlocated at bottom left corner")
                .foregroundStyle(Color.black)
                .fillParent()
                .background(
                    MMColors.mapBg
                )
                .multilineTextAlignment(.center)
        }
    }
}

/////////////////////
/// Preview
////////////////////

struct FilesListView_Previews: PreviewProvider {
    static var previews: some View {
        MMEditorView()
    }
}
