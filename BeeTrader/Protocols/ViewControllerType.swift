//
//  ViewControllerType.swift
//  Bakalarka
//
//  Created by hladek on 04/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation

protocol ViewControllerType: class {
    func viewTypeDidLoad()
    func viewTypeWillAppear(_ animated: Bool)
    func viewTypeDidAppear(_ animated: Bool)
    func viewTypeWillDisappear(_ animated: Bool)
    func viewTypeDidDisappear(_ animated: Bool)
    func viewTypeWillLayoutSubviews()
    func viewTypeDidLayoutSubviews()
}

extension ViewControllerType {
    func viewTypeDidLoad() {}
    func viewTypeWillAppear(_: Bool) {}
    func viewTypeDidAppear(_: Bool) {}
    func viewTypeWillDisappear(_: Bool) {}
    func viewTypeDidDisappear(_: Bool) {}
    func viewTypeWillLayoutSubviews() {}
    func viewTypeDidLayoutSubviews() {}
}
