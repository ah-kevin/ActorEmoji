
import SwiftUI

struct BottomToolbar: View {
  @EnvironmentObject var model: EmojiArtModel

  @State var onDiskAccessCount = 0
  @State var inMemoryAccessCount = 0

  var body: some View {
    HStack {
      Button(action: {
        // Clear on-disk cache
      }, label: {
        Image(systemName: "folder.badge.minus")
      })

      Button(action: {
        // Clear in-memory cache
        Task {
          await ImageDatabase.shared.clearInMemoryAssets()
          try await model.loadImages()
        }
      }, label: {
        Image(systemName: "square.stack.3d.up.slash")
      })

      Spacer()
      Text("Access: \(onDiskAccessCount) from disk, \(inMemoryAccessCount) in memory")
        .font(.monospaced(.caption)())
    }
    .padding(.vertical, 2)
    .padding(.horizontal, 5)
    .task {
      guard let memoryAccessSequence =
        ImageDatabase.shared.imageLoader.inMemoryAccess
      else {
        return
      }
      for await count in memoryAccessSequence {
        inMemoryAccessCount = count
      }
    }
    .task {
          guard let diskAccessSequence = ImageDatabase.shared.onDiskAccess else {
            return
          }
          for await count in diskAccessSequence {
            onDiskAccessCount = count
          }
        }

  }
}
