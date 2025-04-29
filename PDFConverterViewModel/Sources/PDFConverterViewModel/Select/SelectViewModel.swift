//
//  SelectViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import Foundation
import PDFConverterModel
import Combine

public protocol ISelectViewModel {
    var savedFiles: [SavedFilesModel] { get set }
    func loadFiles()
    func deleteSavedFile(by id: Int)
    var type: PDFType { get }
    func addSavedFile(_ model: SavedFilesModel)

    var timeOutSubject: PassthroughSubject<Void, Never> { get }

    var byMultipartResponse: MultiPartResponseModel? { get set }
    var createByMultipartSuccessSubject: PassthroughSubject<Bool, Never> { get }
    func createByMultipartRequest(userId: String, appBundle: String, convertTo: String, password: String?, fileURL: URL)

    var getFileIDSuccessSubject: PassthroughSubject<FileIDResponseModel, Never> { get }
    func startPollingForFileId(by taskID: UUID)

    var getFileSuccessSubject: PassthroughSubject<Data, Never> { get }
    func getFile(by fileID: UUID)

    var userID: String { get set }
}

public class SelectViewModel: ISelectViewModel {

    private let historyService: IHistoryService
    public let networkService: INetworkService
    public let appStorageService: IAppStorageService

    public var savedFiles: [SavedFilesModel] = []

    public var type: PDFType

    public var byMultipartResponse: MultiPartResponseModel?

    public var timeOutSubject = PassthroughSubject<Void, Never>()

    public var createByMultipartSuccessSubject = PassthroughSubject<Bool, Never>()

    public var getFileIDSuccessSubject = PassthroughSubject<FileIDResponseModel, Never>()

    public var getFileSuccessSubject = PassthroughSubject<Data, Never>()

    var cancellables = Set<AnyCancellable>()

    private var pollingCancellable: AnyCancellable?
    private var isPolling = false

    public var userID: String {
        get {
            return appStorageService.getData(key: .apphudUserID) ?? ""
        } set {
            appStorageService.saveData(key: .apphudUserID, value: newValue)
        }
    }

    public init(historyService: IHistoryService,
                networkService: INetworkService,
                navigationModel: SelectNavigationModel,
                appStorageService: IAppStorageService) {
        self.historyService = historyService
        self.networkService = networkService
        self.type = navigationModel.type
        self.appStorageService = appStorageService
    }

    public func addSavedFile(_ model: SavedFilesModel) {
        do {
            _ = try self.historyService.addSavedFile(model)
        } catch {
            print(error)
        }
    }

    public func loadFiles() {
        do {
            self.savedFiles = try self.historyService.getAllSavedFiles()
        } catch {
            print(error)
        }
    }

    public func deleteSavedFile(by id: Int) {
        do {
            try self.historyService.deleteSavedFile(by: id)
        } catch {
            print(error)
        }
    }

    public func createByMultipartRequest(userId: String, appBundle: String, convertTo: String, password: String?, fileURL: URL) {
        Task {
            do {
                let response = try await networkService.createByMultipartRequest(userId: userId, appBundle: appBundle, convertTo: convertTo, password: password, fileURL: fileURL)
                byMultipartResponse = response
                self.createByMultipartSuccessSubject.send(true)
            } catch let error {
                print(error)
                self.createByMultipartSuccessSubject.send(false)
            }
        }
    }

    public func startPollingForFileId(by taskID: UUID) {
        guard !isPolling else { return }
        isPolling = true

        var elapsedTime: TimeInterval = 0
        let pollingInterval: TimeInterval = 25
        let timeout: TimeInterval = 360
        pollingCancellable = Timer
            .publish(every: pollingInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                elapsedTime += pollingInterval

                if elapsedTime >= timeout {
                    self.timeOutSubject.send()
                    self.pollingCancellable?.cancel()
                    self.isPolling = false
                    return
                }

                self.getFileIDRequest(by: taskID)
            }
    }

    public func getFileIDRequest(by taskID: UUID) {
        networkService.getFileID(by: taskID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Get fileID error: \(error)")
                }
            }, receiveValue: { [weak self] responseModel in
                guard let self = self else { return }

                if !responseModel.items.isEmpty {
                    self.pollingCancellable?.cancel()
                    self.isPolling = false

                    self.getFileIDSuccessSubject.send(responseModel)
                } else {
                    print("Still generating... will poll again.")
                }
            })
            .store(in: &cancellables)
    }

    public func getFile(by fileID: UUID) {
        networkService.getFile(by: fileID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Get fileID error: \(error)")
                }
            }, receiveValue: { [weak self] responseModel in
                guard let self = self else { return }

                getFileSuccessSubject.send(responseModel)
            })
            .store(in: &cancellables)
    }
}
