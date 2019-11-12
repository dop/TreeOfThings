import SwiftUI

struct DocumentView: View {
    let documentReader: DocumentReader
    
    init(_ doc: Document) {
        self.documentReader = DocumentReader(doc)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(documentReader.tableOfContents(), id: \.self) { heading in
                    HStack(alignment: .center) {
                        if heading.level > 0 {
                            Text("".padding(toLength: heading.level, withPad: "-", startingAt: 0))
                            Spacer()
                                .frame(width: 3.0)
                            Text(heading.title)
                        } else {
                            Text(heading.title)
                        }
                    }
                }
            }
            .navigationBarTitle(documentReader.title())
        }
    }
}

struct DocumentView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentView(try! parse(resource: "Example"))
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
