// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title SoulboundVotesToken
 * @notice ERC20Votes soulbound: sem transferências nem approvals.
 * - Mint: apenas owner
 * - Burn: titular pode queimar; owner também pode queimar de terceiros
 * - Votes: delegação via ERC20Votes continua funcionando
 */
contract SoulboundVotesToken is ERC20, ERC20Permit, ERC20Votes, Ownable {
    error TransfersDisabled();

    constructor(
        string memory name_,
        string memory symbol_,
        address initialOwner
    )
        ERC20(name_, symbol_)
        ERC20Permit(name_)           // necessário para ERC2612 / signatures
        Ownable(initialOwner)
    {}

    /* ------------ Bloqueio de transferências e approvals ------------ */

    function transfer(address, uint256) public pure override returns (bool) {
        revert TransfersDisabled();
    }

    function transferFrom(address, address, uint256) public pure override returns (bool) {
        revert TransfersDisabled();
    }

    function approve(address, uint256) public pure override returns (bool) {
        revert TransfersDisabled();
    }

    function increaseAllowance(address, uint256) public pure override returns (bool) {
        revert TransfersDisabled();
    }

    function decreaseAllowance(address, uint256) public pure override returns (bool) {
        revert TransfersDisabled();
    }

    /* --------------------------- Mint / Burn ------------------------- */

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function burnFrom(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
    }

    /* ---- Hook central OZ 5.x: bloqueia qualquer move não mint/burn --- */

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Votes)
    {
        // permite somente mint (from == 0) ou burn (to == 0)
        if (from != address(0) && to != address(0)) {
            revert TransfersDisabled();
        }
        super._update(from, to, value);
    }

    /* Overrides exigidos pelo compilador (resolução de herança múltipla) */

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }
}
