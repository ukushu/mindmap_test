
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
            
            TabsPanel()
        }
    }
    
    func TabsPanel() -> some View {
        VStack {
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(model.mMaps) { item in
                        MMapTab(model: model, item: item)
                    }
                    
                    Button("+") {
                        withAnimation {
                            model.add()
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(EdgeInsets(top: 4, leading: 5, bottom: 4, trailing: 5))
            .background( WindowRealBackgroundView() )
        }
    }
}

struct MMapTab: View {
    @ObservedObject var model: MindMapListViewModel
    let item: MindMapItem
    
    @State var inRename: Bool = false
    @State var newName: String = ""
    @FocusState private var focused: Bool
    
    var body: some View {
        if let idx = model.mMaps.firstIndex(where: { $0 == item }) {
            HStack {
                if inRename {
                    TextField(item.name,
                              text: $newName,
                              onCommit: { if newName.count > 0 { item.name = newName }; focused = false; inRename.toggle() }
                    )
                    .focused($focused)
                } else {
                    Button(item.name) {
                        model.seleted = idx
                    }
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 3)
                    .fill( model.seleted == idx ? Color.gray : Color.clear )
            }
            .contextMenu {
                Button("Rename") {
                    newName = item.name
                    focused = true
                    
                    withAnimation {
                        inRename = true
                    }
                }
                
                Divider()
                
                Button("Delete") {
                    withAnimation {
                        model.delete(idx)
                    }
                }
            }
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
