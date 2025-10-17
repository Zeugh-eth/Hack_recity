// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {EIP712} from "../../utils/cryptography/EIP712.sol";
import {Nonces} from "../../utils/Nonces.sol";
import {Checkpoints} from "../../utils/structs/Checkpoints.sol";

/**
 * @dev Core voting and delegation logic.
 * Provides delegation (direct or signature-based), checkpointed voting power tracking,
 * and querying past voting balances for governance snapshots.
 *
 * Based on OpenZeppelin Contracts v5.0.0
 */
abstract contract Votes is EIP712, Nonces {
    using Checkpoints for Checkpoints.Trace224;

    /// @dev Mapping of account => delegatee
    mapping(address => address) private _delegatee;

    /// @dev Account voting power checkpoints
    mapping(address => Checkpoints.Trace224) private _delegateCheckpoints;

    /// @dev Total supply voting power checkpoints
    Checkpoints.Trace224 private _totalCheckpoints;

    /// @dev EIP-712 typehash for delegation by signature
    bytes32 private constant _DELEGATION_TYPEHASH =
        keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");

    event DelegateChanged(
        address indexed delegator,
        address indexed fromDelegate,
        address indexed toDelegate
    );

    event DelegateVotesChanged(
        address indexed delegate,
        uint256 previousBalance,
        uint256 newBalance
    );

    /* -------------------------------------------------------------------------- */
    /*                              External Methods                              */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Returns the current delegate of an account.
     */
    function delegates(address account) public view virtual returns (address) {
        return _delegatee[account];
    }

    /**
     * @notice Returns the current votes balance for an account.
     */
    function getVotes(address account) public view virtual returns (uint256) {
        return _delegateCheckpoints[account].latest();
    }

    /**
     * @notice Returns the total votes at a past block.
     */
    function getPastVotes(address account, uint256 blockNumber)
        public
        view
        virtual
        returns (uint256)
    {
        return _delegateCheckpoints[account].upperLookupRecent(blockNumber);
    }

    /**
     * @notice Returns the total supply of votes at a past block.
     */
    function getPastTotalSupply(uint256 blockNumber)
        public
        view
        virtual
        returns (uint256)
    {
        return _totalCheckpoints.upperLookupRecent(blockNumber);
    }

    /**
     * @notice Delegate votes to `delegatee`.
     */
    function delegate(address delegatee) public virtual {
        _delegate(msg.sender, delegatee);
    }

    /**
     * @notice Delegate by EIP-712 signature.
     */
    function delegateBySig(
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public virtual {
        address signer = _useCheckedNonce(msg.sender, nonce);
        require(block.timestamp <= expiry, "Votes: signature expired");

        // Validate EIP712 signature
        bytes32 structHash = keccak256(
            abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry)
        );
        bytes32 hash = _hashTypedDataV4(structHash);
        address recovered = ECDSA.recover(hash, v, r, s);
        require(recovered != address(0), "Votes: invalid signature");
        _delegate(recovered, delegatee);
    }

    /* -------------------------------------------------------------------------- */
    /*                              Internal Logic                                */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Must be overridden to define the source of voting units (e.g., token balance).
     */
    function _getVotingUnits(address account)
        internal
        view
        virtual
        returns (uint256);

    /**
     * @dev Internal function to move delegated voting power when balances change.
     */
    function _transferVotingUnits(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        if (from == to || amount == 0) return;

        if (from != address(0)) {
            (uint256 oldWeight, uint256 newWeight) =
                _delegateCheckpoints[_delegatee[from]].push(
                    SafeCast.toUint224(
                        _delegateCheckpoints[_delegatee[from]].latest() - amount
                    )
                );
            emit DelegateVotesChanged(_delegatee[from], oldWeight, newWeight);
        }

        if (to != address(0)) {
            (uint256 oldWeight, uint256 newWeight) =
                _delegateCheckpoints[_delegatee[to]].push(
                    SafeCast.toUint224(
                        _delegateCheckpoints[_delegatee[to]].latest() + amount
                    )
                );
            emit DelegateVotesChanged(_delegatee[to], oldWeight, newWeight);
        }
    }

    /**
     * @dev Core delegation logic.
     */
    function _delegate(address account, address delegatee) internal virtual {
        address current = _delegatee[account];
        _delegatee[account] = delegatee;

        emit DelegateChanged(account, current, delegatee);

        uint256 balance = _getVotingUnits(account);
        _transferVotingUnits(current, delegatee, balance);
    }

    /**
     * @dev Called by derived contracts to propagate changes to total voting units.
     */
    function _update(address from, address to, uint256 amount) internal virtual {
        _transferVotingUnits(from, to, amount);
        _moveVotingUnits(from, to, amount);
    }

    function _moveVotingUnits(address from, address to, uint256 amount)
        private
    {
        if (from == to || amount == 0) return;

        if (from != address(0)) {
            (uint256 oldWeight, uint256 newWeight) =
                _totalCheckpoints.push(
                    SafeCast.toUint224(_totalCheckpoints.latest() - amount)
                );
            emit DelegateVotesChanged(address(0), oldWeight, newWeight);
        }

        if (to != address(0)) {
            (uint256 oldWeight, uint256 newWeight) =
                _totalCheckpoints.push(
                    SafeCast.toUint224(_totalCheckpoints.latest() + amount)
                );
            emit DelegateVotesChanged(address(0), oldWeight, newWeight);
        }
    }
}
