import SwiftUI

struct DocumentOverview: View {
    let documentReader: DocumentReader
    
    init(_ doc: Document) {
        self.documentReader = DocumentReader(doc)
    }
    
    var body: some View {
        NavigationView {
            List(documentReader.tableOfContents()) { heading in
                HeadingView(heading.title, padding: heading.level)
            }
            .navigationBarTitle(documentReader.title())
        }
    }
}

struct DocumentOverview_Previews: PreviewProvider {
    static var previews: some View {
        DocumentOverview(try! parse(resource: "Example"))
    }
    
    private static func parse(resource: String) throws -> Document {
        switch (DocumentService().parse(resource: resource)) {
        case .ok(let org):
            return org
        default:
            fatalError("Failed to parse resource \"\(resource)\".")
        }
    }
}
