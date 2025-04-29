//
//  NetworkService.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import UIKit
import PDFConverterModel
import Combine

public protocol INetworkService {
    func createByMultipartRequest(userId: String, appBundle: String, convertTo: String, password: String?, fileURL: URL) async throws -> MultiPartResponseModel
    func getFileID(by taskID: UUID) -> AnyPublisher<FileIDResponseModel, Error>
    func getFile(by fileID: UUID) -> AnyPublisher<Data, Error>
}

public final class NetworkService: INetworkService {

    public init() { }

    public func createByMultipartRequest(
        userId: String,
        appBundle: String,
        convertTo: String,
        password: String?,
        fileURL: URL
    ) async throws -> MultiPartResponseModel {

        var components = URLComponents(string: "https://backend.techinnovatorshubz.shop/api/task")!
        components.queryItems = [
            URLQueryItem(name: "convert_to", value: convertTo),
            URLQueryItem(name: "password", value: password),
            URLQueryItem(name: "app_bundle", value: appBundle),
            URLQueryItem(name: "user_id", value: userId)
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("183eed10-32e5-4a47-9542-8d28229bc3fb", forHTTPHeaderField: "api-token")

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let fileData = try Data(contentsOf: fileURL)
        let filename = fileURL.lastPathComponent
        let mimeType: String

        switch fileURL.pathExtension.lowercased() {
        case "doc", "docx":
            mimeType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case "xls", "xlsx":
            mimeType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case "ppt", "pptx":
            mimeType = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        default:
            mimeType = "application/octet-stream"
        }

        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(fileData)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")

        request.httpBody = body

        let (data, _) = try await URLSession.shared.data(for: request)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("Ответ от сервера: \(jsonString)")
        }

        return try JSONDecoder().decode(MultiPartResponseModel.self, from: data)
    }


    public func getFileID(by taskID: UUID) -> AnyPublisher<FileIDResponseModel, Error> {
        let urlString = "https://backend.techinnovatorshubz.shop/api/task/\(taskID)"

        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("183eed10-32e5-4a47-9542-8d28229bc3fb", forHTTPHeaderField: "api-token")
        request.timeoutInterval = 60

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: FileIDResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func getFile(by fileID: UUID) -> AnyPublisher<Data, Error> {
        let urlString = "https://backend.techinnovatorshubz.shop/api/task/\(fileID)/file"

        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("183eed10-32e5-4a47-9542-8d28229bc3fb", forHTTPHeaderField: "api-token")
        request.timeoutInterval = 60

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data // просто возвращаем Data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
