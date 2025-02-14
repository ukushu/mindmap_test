
import SwiftUI
import MoreSwiftUI

struct MMEditorView: View {
    @StateObject var model: MMEditorViewModel = MMEditorViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            TopMenuBar()
            
            EditorCanvas()
            
            TabsPanelView(model: model)
        }
    }
    
    @ViewBuilder
    func TopMenuBar() -> some View {
        HStack(spacing: 10) {
            if let selectedIdx = model.seleted, selectedIdx <= model.mMaps.count {
                Button("+") {
                    model.mMaps[selectedIdx].addNode("Bla")
                }
                
                Button("-") {
                    if model.mMaps[selectedIdx].selection.selectedNodeIDs.count > 0 {
                        model.mMaps[selectedIdx].removeSelectedNodes()
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .frame(height: 30)
    }
    
    @ViewBuilder
    func EditorCanvas() -> some View {
        if let selectedIdx = model.seleted, selectedIdx <= model.mMaps.count {
            MindMapSurfaceView( model: model.mMaps[selectedIdx] )
        } else {
            VStack {
                Spacer()
                
                HStack {
                    Text("Create your first MindMap using \"+\"")
                        .foregroundStyle(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(15)
                    
                    Spacer()
                }
            }
            .background( MMColors.mapBg )
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
