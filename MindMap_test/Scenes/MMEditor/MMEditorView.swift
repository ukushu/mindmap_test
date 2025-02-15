
import SwiftUI
import MoreSwiftUI

struct MMEditorView: View {
    @StateObject var model: MMEditorViewModel = MMEditorViewModel()
    
    @State var color = Color.black
    
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
                
                Button("+ child") {
                    
                }
                
                Button("Relationship") {
                    
                }
                
                Button("Boundary") {
                    
                }
                
                PopoverButtSimple(label: { Text("Modify") }) {
                    VStack(alignment: .leading, spacing: 5) {
                        CtxMenuBtn(sfImg: "trash", lbl: "Note") { }
                        CtxMenuBtn(sfImg: "trash", lbl: "Label") { }
                        CtxMenuBtn(sfImg: "trash", lbl: "Task") { }
                    }
                    .buttonStyle(BtnUksStyle.default)
                    .padding(15)
                }
                
                PopoverButtSimple(label: { Text("Style") }) {
                    VStack(alignment: .leading, spacing: 5) {
                        CtxMenuBtn(sfImg: "trash", lbl: "Circle") { }
                        CtxMenuBtn(sfImg: "trash", lbl: "Capsule") { }
                        CtxMenuBtn(sfImg: "trash", lbl: "Rectangle") { }
                        CtxMenuBtn(sfImg: "trash", lbl: "RoundedRectangle") { }
                    }
                    .buttonStyle(BtnUksStyle.default)
                    .padding(15)
                }
                
//                if let sel = model.selected {
                    UksColorPicker(color: $color)
                        .frame(width: 17, height: 17)
//                }
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
