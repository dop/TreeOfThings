import SwiftUI

struct DocumentOverview: View {
    let document: Document
    
    init(_ doc: Document) {
        self.document = doc
    }
    
    var body: some View {
        List(document.headingList) { heading in
            NavigationLink (destination: SubtreeView(heading: heading)) {
                HeadingView(heading)
            }
        }
        .navigationBarTitle(document.title)
    }
}

struct DocumentOverview_Previews: PreviewProvider {
    static var previews: some View {
        DocumentOverview(try! parseExample("Example"))
    }
    
    private static func parseExample(_ resource: String) throws -> Document {
        switch (DocumentService().parse(resource: resource)) {
        case .ok(let org):
            return org.toDocument()
        default:
            fatalError("Failed to parse resource \"\(resource)\".")
        }
    }
}
