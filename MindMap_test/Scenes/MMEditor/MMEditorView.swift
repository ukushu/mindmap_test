
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
            if let selected = model.selected {
                Button("+") {
                    selected.addNode("Bla")
                }
                
                Button("-") {
                    selected.removeSelectedNodes()
                }
                .disabled(selected.selection.selectedNodeIDs.count == 0)
            }
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .frame(height: 30)
    }
    
    @ViewBuilder
    func EditorCanvas() -> some View {
        if let selected = model.selected {
            MindMapSurfaceView( model: selected )
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
