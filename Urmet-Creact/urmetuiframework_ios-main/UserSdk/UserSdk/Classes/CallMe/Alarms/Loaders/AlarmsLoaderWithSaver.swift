//
//  AlarmsLoaderWithSaver.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 23/12/22.
//

class AlarmsLoaderWithSaver: IAlarmsLoader {
    private let loader: IAlarmsLoader
    private let saver: IAlarmsSaver

    init(loader: IAlarmsLoader, saver: IAlarmsSaver) {
        self.loader = loader
        self.saver = saver
    }

    func get(forPlace place: Place, completion: @escaping Completion) {
        loader.get(forPlace: place) { result in
            switch result {
            case let .success(alarms):
                completion(.success(alarms))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func update(forPlace place: Place, completion: @escaping Completion) {
        get(forPlace: place) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(alarms):
                self.saver.insert(alarms, forPlace: place) { error in
                    if let error {
                        return completion(.failure(error))
                    }

                    completion(.success(alarms))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
