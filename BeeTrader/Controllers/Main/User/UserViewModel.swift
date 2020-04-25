
import Alamofire
import Foundation
protocol ViewModel {
    func viewModelDidLoad()
}

class UserViewModel: ViewModel {
    var loadDataparameters: Parameters? {
        guard let email = GlobalUser.shared.user?.email else {
            delegate?.presentFailure()
            return nil
        }
        return RequestParameters.userData(email: email)
    }
    var handleLogOut: EmptyClosure?

    var delegate: UserViewDelegate?

    func viewModelDidLoad() {
        loadData() //todo
    }

    func loadData() {
        delegate?.showHUD()
        UrlRequest<User>().handle(ApiConstants.baseUrl + "userByEmail",
                                  methood: HTTPMethod.get,
                                  parameters: loadDataparameters) { [weak self] result in
            switch result {
            case .failure:
                self?.delegate?.presentFailure()
            case let .success(response):
                guard let user = response.data else {
                    self?.delegate?.presentFailure()
                    return
                }
                GlobalUser.shared.update(user)
                self?.delegate?.showUserInfo(user)
            }
            self?.delegate?.hideHUD()
        }
    }

    func handleEditController() {
        let storyboard = UIStoryboard(name: "UserDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.userDetail) as! UserDetailViewController
        controller.viewModel.userUpdateCompletion = { [weak self] _ in
            self?.loadData()
        }
        delegate?.presetnEditController(controller)
    }
}
