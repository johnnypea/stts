//
//  Vimeo.swift
//  stts
//

import Foundation

class Vimeo: StatusPageService {
    override var url: URL { return URL(string: "http://www.vimeostatus.com")! }
    override var statusPageID: String { return "sccqh0pnqrh8" }
}