import Foundation

protocol CatalogProviding: Sendable {
    func fetchCatalog() -> [MediaItem]
}

struct CatalogService: CatalogProviding {
    func fetchCatalog() -> [MediaItem] {
        [
            MediaItem(
                title: "Interstellar",
                kind: .movie,
                synopsis: "A crew crosses a wormhole to save humanity.",
                posterURL: URL(string: "https://picsum.photos/id/1011/600/900")!,
                trailerURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
            ),
            MediaItem(
                title: "Dune",
                kind: .movie,
                synopsis: "A noble family fights for control of Arrakis.",
                posterURL: URL(string: "https://picsum.photos/id/1015/600/900")!,
                trailerURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!
            ),
            MediaItem(
                title: "The Batman",
                kind: .movie,
                synopsis: "Batman uncovers corruption in Gotham.",
                posterURL: URL(string: "https://picsum.photos/id/1021/600/900")!,
                trailerURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")!
            ),
            MediaItem(
                title: "Inception",
                kind: .movie,
                synopsis: "A thief enters dreams to plant an idea.",
                posterURL: URL(string: "https://picsum.photos/id/1033/600/900")!,
                trailerURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!
            ),
            MediaItem(
                title: "Signal",
                kind: .series,
                synopsis: "A profiler and detective connect across time.",
                posterURL: URL(string: "https://picsum.photos/id/1043/600/900")!,
                trailerURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4")!
            ),
            MediaItem(
                title: "The Last of Us",
                kind: .series,
                synopsis: "Two survivors cross a ruined United States.",
                posterURL: URL(string: "https://picsum.photos/id/1050/600/900")!,
                trailerURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4")!
            ),
            MediaItem(
                title: "Severance",
                kind: .series,
                synopsis: "Office workers split memories between work and home.",
                posterURL: URL(string: "https://picsum.photos/id/1062/600/900")!,
                trailerURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4")!
            ),
            MediaItem(
                title: "Shogun",
                kind: .series,
                synopsis: "A sailor is drawn into power struggles in feudal Japan.",
                posterURL: URL(string: "https://picsum.photos/id/1074/600/900")!,
                trailerURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4")!
            )
        ]
    }
}
