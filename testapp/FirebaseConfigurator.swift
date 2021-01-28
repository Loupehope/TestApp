import Firebase

enum FirebaseConfigurator {
    
    private static var resourceName: String {
        return "GoogleService-Info"
    }

    static func configure() {
        guard let filePath = Bundle.main.path(forResource: resourceName, ofType: .fileExtension),
            let options = FirebaseOptions(contentsOfFile: filePath) else {
                return
        }

        FirebaseApp.configure(options: options)
    }
}

// MARK: - Constants
private extension String {
    static let fileExtension = "plist"
}
