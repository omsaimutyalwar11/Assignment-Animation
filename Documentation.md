# Task 4 Documentation

# Assignment 1 – Square View Animation

## Problem Statement

Create a square view and an **Animate** button. When the button is tapped, use `UIView.animate` to move the square to a new position and increase its size. When tapped again, animate it back to its original position and size. Configure the animation using parameters such as duration, delay, and animation curve.

## Implementation

- Created a `squareView` and an `animateButton` and added them to the view hierarchy with the required Auto Layout constraints.
- Added an `isExpanded` property to keep track of the square's expanded and collapsed states.
- Stored the `topConstraint` and `widthConstraint` as properties because their constants need to be modified during the animation.
- Added a height constraint equal to the square's width to maintain its square shape.
- Created the `performAction` method, which is called when the **Animate** button is tapped.
- Inside `performAction`, the `isExpanded` state is toggled:
  - When `isExpanded` is `true`, the top constraint is changed to `20` and the width constraint to `200`. This moves the square towards the top and increases its size.
  - When `isExpanded` is `false`, the top constraint is changed back to `400` and the width constraint to `50`. This returns the square to its original position and size.
- Used `UIView.animate` to animate the constraint changes with:
  - **Duration:** `0.5` seconds
  - **Delay:** `0.5` seconds
  - **Animation Curve:** `.curveEaseInOut`
- Called `layoutIfNeeded()` inside the animation block to animate the Auto Layout constraint changes smoothly.

```
UIView.animate(
    withDuration: 0.5,
    delay: 0.5,
    options: [.curveEaseInOut]
) { [weak self] in
    self?.view.layoutIfNeeded()
}
```
## Result
- When the Animate button is tapped, the square view goes to upside with increasing size and after tapping again the square view come back to it original size and position.

# Assignment 2 – Bouncing ball animation using CAKeyframeAnimation

## Problem Statement
Create a bouncing ball animation using CAKeyframeAnimation, where the ball follows a curved path and gradually settles back to its original position.

## Implementation

- Created a `ballLayer` using `CALayer` and an `animateButton` using `UIButton`. Added them to the view hierarchy with the required frame and Auto Layout constraints.
- Stored the ball's initial position in the `originalPosition` property so that the animation can return the ball to its starting point.
- Created the `animateButtonTapped` action method, which is called when the **Animate** button is tapped.
- Before starting a new animation, checked whether an animation with the key `"bounce"` is already running. This prevents multiple animations from being added while the current animation is still in progress.
  ```
  guard ballLayer.animation(forKey: "bounce") == nil else {
      return
  }
  ```
- Created a `pathForBounceAnimation()` method that returns the `CAKeyframeAnimation` used for the bouncing effect.
- Inside `pathForBounceAnimation()`:
    - Created a `CAKeyframeAnimation` with "position" as the key path to animate the ball's position.
    - Created a `UIBezierPath` to define the ball's movement.
    - Added multiple Bezier curves with different control points to create a smooth bouncing path.
    - Added three main bounces with gradually decreasing heights.
    - Added a final curve that makes the ball come back to its originalPosition, creating the settling effect.
    - Set the animation duration to `4.0 seconds`.
    - Applied the `.easeInEaseOut` timing function to make the animation start and end smoothly.
    - Added the generated animation to `ballLayer` using the "bounce" key:
```
let animation = pathForBounceAnimation()
ballLayer.add(animation, forKey: "bounce")
```
## Result
- When the Animate button is tapped, the ball follows the predefined curved path, performs multiple bounces with gradually decreasing heights, and finally returns to its original position with a smooth settling effect.

# Assignment 3 – Animate a view using UIViewPropertyAnimator.

## Problem Statement
Create a view and animate it using UIViewPropertyAnimator. Add controls to start, pause, resume and reverse the animation. The animation should be controllable while it is running.

## Implementation

- Created a `createButton(title: String)` utility method to configure and create `UIButton` instances.
- Created four control buttons using the utility method:
  - `startButton`
  - `pauseButton`
  - `resumeButton`
  - `reverseButton`
- Added all four buttons to a horizontal `UIStackView` named `buttonView` and positioned the stack view using Auto Layout constraints.
- Created a `squareView` with an initial frame and added it to the view hierarchy.
- Created a `UIViewPropertyAnimator` with a duration of `5.0` seconds and a damping ratio of `0.5`:
```
  let animator = UIViewPropertyAnimator(duration: 5.0, dampingRatio: 0.5)
```
- Added the required below animations to the property animator:
    - Moves the squareView vertically by 450 points.
    - Changes the square's background color from red to system blue.
```
animator.addAnimations { [weak self] in
    guard let self else {
        return
    }

    self.squareView.center.y += 450
    self.squareView.backgroundColor = .systemBlue
}
```
### Start Animation
- The Start button starts the animation using `animator.startAnimation(afterDelay: 0.3)`.
- Before starting, the animator's state is checked to make sure it is `.inactive`.
- This prevents attempting to start an animator that has already been started or paused.
- Action method - `startAnimation()`
```
if animator.state == .inactive {
    animator.startAnimation(afterDelay: 0.3)
}
```

### Pause Animation
- The Pause button pauses the animation only when the animator is currently running.
- `pauseAnimation()` preserves the current animation progress, allowing it to be continued later.
- Action method - `pauseAnimation()`
```
if animator.isRunning {
    animator.pauseAnimation()
}
```
### Resume Animation
- The Resume button continues the animation from its current position.
- `continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve: .easeInOut), durationFactor: 0.5)` is used to resume the paused animation with an `.easeInOut` timing curve.
- Action method - `resumeAnimation()`

### Reverse Animation
- The Reverse button toggles the `isReversed` property of the animator.
- This allows the animation to play in the opposite direction from its current state.
```
animator.isReversed.toggle()
```
- Action method - `reverseAnimation()`

### Interactive Gesture Control
- In addition to the button controls, a UIPanGestureRecognizer is added to make the animation interactively controllable through a horizontal swipe.
- Created a separate `UIViewPropertyAnimator` named `horizontalAnimator` for controlling the horizontal movement of the square.
- When the pan gesture begins:
    - The swipe velocity is checked to determine the direction.
    - The square is configured to move horizontally by 100 points in the swipe direction.
    - The animator is started and immediately paused so that its progress can be controlled manually.
- While the gesture changes:
    - The horizontal translation is converted into a fractional progress value.
    - The animator's fractionComplete is updated based on the swipe distance.
```
let progress = translation.x / view.bounds.width
horizontalAnimator?.fractionComplete = progress
```
- When the gesture ends or is cancelled, the animator continues from its current progress.
```
horizontalAnimator?.continueAnimation(
    withTimingParameters: nil,
    durationFactor: 0
)
```
