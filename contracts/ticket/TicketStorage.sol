//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "../MelondeAccessControl.sol";

contract TicketStorage is MelondeAccessControl {

  event TicketCreated(
    uint256 id,
    address owner,
    string title,
    string description,
    string location,
    uint256 saleTime,
    uint256 eventTime,
    string thumbnail,
    string externalUrl,
    uint256 amount,
    uint256 priceInMLD
  );

  struct Ticket {
    uint256 id;
    address owner;
    string title;
    string description;
    string location;
    uint256 saleTime;
    uint256 eventTime;
    string thumbnail;
    string externalUrl;
    uint256 amount;
    uint256 priceInMLD;
  }

  uint256[] public allTickets;
  mapping(uint256 => Ticket) internal tickets;
  mapping(address => mapping(uint256 => uint256)) internal holders;
}
