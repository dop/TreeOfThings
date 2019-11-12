import SwiftUI

struct DocumentOverview: View {
    let documentReader: DocumentReader
    
    init(_ documentReader: DocumentReader) {
        self.documentReader = documentReader
    }
    
    init(_ doc: Document) {
        self.documentReader = DocumentReader(doc)
    }
    
    var body: some View {
        List(documentReader.tableOfContents()) { heading in
            NavigationLink (destination: SubtreeView(title: heading.title)) {
                HeadingView(heading.title, padding: heading.level)
            }
        }
        .navigationBarTitle(documentReader.title())
    }
}

struct DocumentOverview_Previews: PreviewProvider {
    static var previews: some View {
        DocumentOverview(try! parseExample("Example"))
    }
    
    private static func parseExample(_ resource: String) throws -> Document {
        switch (DocumentService().parse(resource: resource)) {
        case .ok(let org):
            return org
        default:
            fatalError("Failed to parse resource \"\(resource)\".")
        }
    }
}
