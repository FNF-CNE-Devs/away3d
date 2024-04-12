package away3d.animators.transitions;

import away3d.animators.IAnimator;
import away3d.animators.states.SkeletonBinaryLERPState;
import away3d.animators.transitions.CrossfadeTransitionNode;
import away3d.events.AnimationStateEvent;

class CrossfadeTransitionState extends SkeletonBinaryLERPState {
	private var _crossfadeAnimationNode:CrossfadeTransitionNode;
	private var _animationStateTransitionComplete:AnimationStateEvent;

	public function new(animator:IAnimator, crossfadeAnimationNode:CrossfadeTransitionNode) {
		super(animator, crossfadeAnimationNode);

		_crossfadeAnimationNode = crossfadeAnimationNode;
	}

	override private function updateTime(time:Int):Void {
		blendWeight = Math.abs(time - _crossfadeAnimationNode.startBlend) / (1000 * _crossfadeAnimationNode.blendSpeed);

		if (blendWeight >= 1) {
			blendWeight = 1;
			if (_animationStateTransitionComplete == null)
				_animationStateTransitionComplete = new AnimationStateEvent(AnimationStateEvent.TRANSITION_COMPLETE, _animator, this, _crossfadeAnimationNode);
			_crossfadeAnimationNode.dispatchEvent(_animationStateTransitionComplete);
		}

		super.updateTime(time);
	}
}
