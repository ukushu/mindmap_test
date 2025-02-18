
import SwiftUI
import UniformTypeIdentifiers

struct TabsPanelView: View {
    @ObservedObject var model: MMEditorViewModel
    
    let rows: [GridItem] = [GridItem(.flexible(minimum: 10, maximum: 120), spacing: 4, alignment: .leading) ]
    
    @State private var dragging: MindMapFile?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows) {
                ForEach(model.mMaps) { item in
                    MMapTabDraggable(model: model, item: item)
                }
                
                Button("+") {
                    withAnimation {
                        model.add()
                    }
                }
                
                Spacer()
            }
            .animation(.default, value: model.mMaps)
            .frame(height: 20)
        }
        .padding(EdgeInsets(top: 0, leading: 5, bottom: 6, trailing: 5))
        .background( Color(hex: 0x303030) )
    }
}

extension TabsPanelView {
    func MMapTabDraggable(model: MMEditorViewModel, item: MindMapFile) -> some View {
        MMapTab(model: model, item: item)
            .onDrag {
                self.dragging = item
                return NSItemProvider(object: String(item.id) as NSString)
            }
            .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: item, listData: $model.mMaps, current: $dragging))
    }
}

fileprivate struct MMapTab: View {
    @ObservedObject var model: MMEditorViewModel
    let item: MindMapFile
    
    @State var inRename: Bool = false
    @State var newName: String = ""
    @FocusState private var focused: Bool
    
    var body: some View {
        if let idx = model.mMaps.firstIndex(where: { $0 == item }) {
            TrueBody(idx: idx)
                .contextMenu {
                    Button("Rename") {
                        newName = item.name
                        focused = true
                        
                        withAnimation {
                            inRename = true
                        }
                    }
                    
                    Divider()
                    
                    Button("Duplicate") {
                        model.duplicate(idx)
                    }
                    
                    Button("Delete") {
                        withAnimation {
                            model.delete(idx)
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    func TrueBody(idx: Int) -> some View {
        HStack {
            if inRename {
                TextField(item.name,
                          text: $newName,
                          onCommit: { if newName.count > 0 { item.name = newName }; focused = false; inRename.toggle() }
                )
                .focused($focused)
            } else {
                Text(item.name)
                    .padding(EdgeInsets(horizontal: 9, vertical: 3))
                    .background {
                        Rectangle()
                            .fill(model.selectedIdx == idx ? Color.gray : Color.gray.opacity(0.3) )
                            .clipShape( .rect(topLeadingRadius: 0, bottomLeadingRadius: 7, bottomTrailingRadius: 7, topTrailingRadius: 0 ) )
                    }
                    .onTapGesture(count: 1) {
                        model.selected = model.mMaps[idx]
                    }
            }
        }
    }
}

fileprivate struct DragRelocateDelegate: DropDelegate {
    let item: MindMapFile
    @Binding var listData: [MindMapFile]
    @Binding var current: MindMapFile?
    
    func dropEntered(info: DropInfo) {
        if item != current {
            let from = listData.firstIndex(of: current!)!
            let to = listData.firstIndex(of: item)!
            if listData[to].id != current!.id {
                listData.move(fromOffsets: IndexSet(integer: from),
                    toOffset: to > from ? to + 1 : to)
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
}
