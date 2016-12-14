import Foundation
import SchemaParser

typealias Identifier = String

// MARK:- SOAP Types

indirect enum SwiftType {
    case identifier(Identifier)
    case optional(SwiftType)
    case array(SwiftType)

    init(type: String, element: Element) {
        switch (element.occurs?.startIndex, element.occurs?.endIndex) {
        case (0?, 1?): self = .optional(.identifier(type))
        case (nil, nil), (1?, 1?): self = .identifier(type)
        default: self = .array(.identifier(type))
        }
    }
}

struct SwiftProperty {
    let name: String
    let type: SwiftType
}

protocol SwiftMetaType: LinesOfCodeConvertible {
    var name: String { get }
}


struct SwiftTypeClass: SwiftMetaType {
    let name: Identifier
    let superName: String?
    let protocols: [String]
    let properties: [SwiftProperty]
    let nestedTypes: [SwiftMetaType]
    let members: [LinesOfCodeConvertible]

    public init(name: String, superName: String? = nil, protocols: [String] = [], properties: [SwiftProperty] = [], nestedTypes: [SwiftMetaType] = [], members: [LinesOfCodeConvertible] = []) {
        self.name = name
        self.superName = superName
        self.protocols = protocols
        self.properties = properties
        self.nestedTypes = nestedTypes
        self.members = members
    }
}

struct SwiftEnum: SwiftMetaType {
    let name: Identifier
    let rawType: SwiftType
    let cases: [String: String]
}

struct SwiftParameter {
    let name: String
    let type: SwiftType
}


// MARK:- SOAP Client

struct SwiftClientClass: SwiftMetaType {
    let name: Identifier
    let methods: [ServiceMethod]
}

struct ServiceMethod {
    let name: String
    let input: Message
    let output: Message

    init(operation: PortType.Operation, input: Message, output: Message) {
        name = operation.name.localName.toSwiftPropertyName()
        self.input = input
        self.output = output
    }
}
