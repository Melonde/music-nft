//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';

import './TicketStorage.sol';

contract TicketNFT is ERC721, TicketStorage {
  
  using SafeMath for uint256;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdTracker;
  address private _beneficiary;
  ERC20 private _currency;

  constructor()
    ERC721("MelondeTicket", "MLT")
  {
    _tokenIdTracker.increment();
  }

  function setBeneficiary(address __beneficiary)
    public
  {
    require(hasRole(ADMIN_ROLE, _msgSender()), "Must have admin role to set beneficiary");
    _beneficiary = __beneficiary;
  }

  function setCurrency(address __currency) 
    public
  {
    require(hasRole(ADMIN_ROLE, _msgSender()), "Must have admin role to set currency");
    _beneficiary = __currency;
  }

  function mint(
    Ticket memory _ticket
  ) 
    public 
    virtual 
    returns(uint256)
  {
    uint256 _currentId = _tokenIdTracker.current();
    _ticket.id = _currentId;
    _ticket.owner = msg.sender;

    _safeMint(msg.sender, _currentId);
    _tokenIdTracker.increment();

    tickets[_currentId] = _ticket;
    allTickets.push(_currentId);

    return _currentId;
  }

  function purchase(
    uint256 _ticketId,
    uint256 _amount
  )
    external 
    payable 
  {
    Ticket storage _ticket = tickets[_ticketId];
    require(_ticket.id > 0, "Non existence ticket");
    require(_ticket.amount > 0, "Out of stock");
    require(_amount > _ticket.amount, "Not enough stock");
    require(_currency.balanceOf(msg.sender) >= _amount.mul(_ticket.priceInMLD), "Dont have enough MLD");

    // transfer MLD to beneficiary address
    _currency.transfer(_beneficiary, _amount.mul(_ticket.priceInMLD));

    // deduce amount
    _ticket.amount -= _amount;

    // add amount to buyer
    holders[msg.sender][_ticketId] += _amount;
  }

}
