
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
                        if let idx = model.mMaps.firstIndex(where: { $0 == item }) {
                            Button(item.name) {
                                model.seleted = idx
                            }
                            .background {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill( model.seleted == idx ? Color.gray : Color.clear )
                            }
                            .contextMenu {
                                Button("Delete") {
                                    withAnimation {
                                        model.delete(idx)
                                    }
                                }
                            }
                        }
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

/////////////////////
/// Preview
////////////////////

struct FilesListView_Previews: PreviewProvider {
    static var previews: some View {
        MindMapListView()
    }
}
