//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

import '../MelondeAccessControl.sol';

contract Melonde is MelondeAccessControl, ERC20 {

  constructor() ERC20("Melonde", "MLD") {}

  function mint(address to, uint256 amount) public virtual {
    require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to mint");
    _mint(to, amount);
  }

}