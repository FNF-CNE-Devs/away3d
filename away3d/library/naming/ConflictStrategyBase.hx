package away3d.library.naming;

import away3d.errors.AbstractMethodError;
import away3d.events.Asset3DEvent;
import away3d.library.assets.IAsset;

/**
 * Abstract base class for naming conflict resolution classes. Extend this to create a
 * strategy class which the asset library can use to resolve asset naming conflicts, or
 * use one of the bundled concrete strategy classes:
 *
 * <ul>
 *   <li>IgnoreConflictStrategy (ConflictStrategy.IGNORE)</li>
 *   <li>ErrorConflictStrategy (ConflictStrategy.THROW_ERROR)</li>
 *   <li>NumSuffixConflictStrategy (ConflictStrategy.APPEND_NUM_SUFFIX)</li>
 * </ul>
 *
 * @see away3d.library.Asset3DLibrary.conflictStrategy
 * @see away3d.library.naming.ConflictStrategy
 * @see away3d.library.naming.IgnoreConflictStrategy
 * @see away3d.library.naming.ErrorConflictStrategy
 * @see away3d.library.naming.NumSuffixConflictStrategy
 */
class ConflictStrategyBase {
	public function new() {}

	/**
	 * Resolve a naming conflict between two assets. Must be implemented by concrete strategy
	 * classes.
	 */
	public function resolveConflict(changedAsset:IAsset, oldAsset:IAsset, assetsDictionary:Dynamic, precedence:String):Void {
		throw new AbstractMethodError();
	}

	/**
	 * Create instance of this conflict strategy. Used internally by the Asset3DLibrary to
	 * make sure the same strategy instance is not used in all Asset3DLibrary instances, which
	 * would break any state caching that happens inside the strategy class.
	 */
	public function create():ConflictStrategyBase {
		throw new AbstractMethodError();
		return null;
	}

	/**
	 * Provided as a convenience method for all conflict strategy classes, as a way to finalize
	 * the conflict resolution by applying the new names and dispatching the correct events.
	 */
	private function updateNames(ns:String, nonConflictingName:String, oldAsset:IAsset, newAsset:IAsset, assetsDictionary:Map<String, IAsset>,
			precedence:String):Void {
		var loser_prev_name:String;
		var winner:IAsset, loser:IAsset;

		winner = (precedence == ConflictPrecedence.FAVOR_NEW) ? newAsset : oldAsset;
		loser = (precedence == ConflictPrecedence.FAVOR_NEW) ? oldAsset : newAsset;

		loser_prev_name = loser.name;

		assetsDictionary[winner.name] = winner;
		assetsDictionary[nonConflictingName] = loser;
		loser.resetAssetPath(nonConflictingName, ns, false);

		loser.dispatchEvent(new Asset3DEvent(Asset3DEvent.ASSET_CONFLICT_RESOLVED, loser, loser_prev_name));
	}
}
