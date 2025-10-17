// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "../ERC20.sol";
import {ERC20Permit} from "./ERC20Permit.sol";
import {Votes} from "../../governance/utils/Votes.sol";

/**
 * @dev Extension of ERC20 to support voting and delegation, compatible with ERC20Permit.
 *
 * This contract keeps track of voting power by storing checkpoints of each account’s balance and total supply.
 * Voting power can be delegated and is automatically adjusted upon mint/burn/transfer.
 *
 * Based on OpenZeppelin Contracts (last updated v5.0.0)
 */
abstract contract ERC20Votes is ERC20, ERC20Permit, Votes {
    constructor() {
        // Empty constructor, nothing to initialize
    }

    // The voting power for an account is determined by its balance
    function _getVotingUnits(address account)
        internal
        view
        virtual
        override
        returns (uint256)
    {
        return balanceOf(account);
    }

    // Hook that updates checkpoints whenever tokens move, are minted or burned
    function _update(address from, address to, uint256 value)
        internal
        virtual
        override(ERC20, Votes)
    {
        super._update(from, to, value);
    }

    // Propagate minting changes to the voting checkpoint system
    function _mint(address to, uint256 amount)
        internal
        virtual
        override(ERC20, Votes)
    {
        super._mint(to, amount);
    }

    // Propagate burning changes to the voting checkpoint system
    function _burn(address account, uint256 amount)
        internal
        virtual
        override(ERC20, Votes)
    {
        super._burn(account, amount);
    }
}
