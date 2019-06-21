import KsApi
import Library
import Prelude
import Prelude_UIKit
import UIKit

final class PledgeAmountCell: UITableViewCell, ValueCell {
  // MARK: - Properties

  private let viewModel = PledgeAmountCellViewModel()

  private lazy var adaptableStackView: UIStackView = { UIStackView(frame: .zero) }()
  private lazy var amountInputView: AmountInputView = { AmountInputView(frame: .zero) }()
  private lazy var titleLabel: UILabel = { UILabel(frame: .zero) }()
  private lazy var rootStackView: UIStackView = { UIStackView(frame: .zero) }()
  private lazy var spacer: UIView = {
    UIView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  private lazy var stepper: UIStepper = { UIStepper(frame: .zero) }()

  // MARK: - Lifecycle

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    _ = self
      |> \.accessibilityElements .~ [self.titleLabel, self.stepper, self.amountInputView]

    _ = (self.rootStackView, self.contentView)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    _ = ([self.titleLabel, self.adaptableStackView], self.rootStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = ([self.stepper, self.spacer, self.amountInputView], self.adaptableStackView)
      |> ksr_addArrangedSubviewsToStackView()

    self.spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: Styles.grid(3)).isActive = true

    self.bindViewModel()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Styles

  override func bindStyles() {
    super.bindStyles()

    _ = self
      |> checkoutBackgroundStyle

    _ = self.adaptableStackView
      |> checkoutAdaptableStackViewStyle(
        self.traitCollection.preferredContentSizeCategory.isAccessibilityCategory
      )

    _ = self.titleLabel
      |> checkoutBackgroundStyle
    _ = self.titleLabel
      |> checkoutTitleLabelStyle
      |> \.text %~ { _ in Strings.Your_pledge_amount() }

    _ = self.rootStackView
      |> checkoutStackViewStyle

    _ = self.stepper
      |> stepperStyle
  }

  // MARK: - Binding

  override func bindViewModel() {
    super.bindViewModel()

    self.amountInputView.label.rac.text = self.viewModel.outputs.currency
    self.amountInputView.textField.rac.text = self.viewModel.outputs.amount
  }

  // MARK: - Configuration

  func configureWith(value: (project: Project, reward: Reward)) {
    self.viewModel.inputs.configureWith(project: value.project, reward: value.reward)
  }
}

// MARK: - Styles

private func stepperStyle(_ stepper: UIStepper) -> UIStepper {
  return stepper
    |> \.tintColor .~ UIColor.clear
    <> UIStepper.lens.decrementImage(for: .normal) .~ image(named: "stepper-decrement-normal")
    <> UIStepper.lens.decrementImage(for: .disabled) .~ image(named: "stepper-decrement-disabled")
    <> UIStepper.lens.decrementImage(for: .highlighted) .~ image(named: "stepper-decrement-highlighted")
    <> UIStepper.lens.incrementImage(for: .normal) .~ image(named: "stepper-increment-normal")
    <> UIStepper.lens.incrementImage(for: .disabled) .~ image(named: "stepper-increment-disabled")
    <> UIStepper.lens.incrementImage(for: .highlighted) .~ image(named: "stepper-increment-highlighted")
}
