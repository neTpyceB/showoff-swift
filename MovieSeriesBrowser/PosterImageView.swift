import SwiftUI
import UIKit

struct PosterImageView: View {
    let url: URL
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .task(id: url) {
            image = await PosterImageCache.shared.image(for: url)
        }
    }
}

actor PosterImageCache {
    static let shared = PosterImageCache()

    private var images: [URL: UIImage] = [:]

    func image(for url: URL) async -> UIImage? {
        if let cached = images[url] {
            return cached
        }

        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        guard let (data, _) = try? await URLSession.shared.data(for: request),
              let image = UIImage(data: data) else {
            return nil
        }

        images[url] = image
        return image
    }
}
