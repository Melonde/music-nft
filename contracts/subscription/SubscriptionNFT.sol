//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/utils/Counters.sol';

import './SubscriptionStorage.sol';

contract SubscriptionNFT is ERC721, SubscriptionStorage {

  using Counters for Counters.Counter;

  Counters.Counter private _tokenIdTracker;
  uint256 private _subscriptionId;
  address private _beneficiary;
  ERC20 private _currency;

  constructor()
    ERC721("MelondeSubscription", "MLS")
  {
    _tokenIdTracker.increment();
    _subscriptionId++;
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
    Subscription memory _subscription
  ) 
    public 
    virtual 
    returns(uint256)
  {
    require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to mint");
    uint256 _currentId = _subscriptionId;
    _subscriptionId++;

    _subscription.id = _currentId;

    _mint(msg.sender, _currentId);
    subscriptions[_currentId] = _subscription;

    return _currentId;
  }

  function subscibe(
    uint256 _subscriptionId,
    uint256 _mldAmount
  ) 
    external 
    payable 
    returns(uint256)
  {
    Subscription memory _subscription = subscriptions[_subscriptionId];
    require(_subscription.id > 0, "Non existence subscription plan");
    require(_mldAmount >= _subscription.priceInMLD, "Not sent enough MLD");
    require(_currency.balanceOf(msg.sender) >= _subscription.priceInMLD, "Dont have enough MLD");

    // transfer MLD to beneficiary address
    _currency.transfer(_beneficiary, _mldAmount);

    // create new subscriber
    uint256 _currentId = _tokenIdTracker.current();
    Subscriber memory _subscriber = Subscriber(
      _currentId,
      _subscriptionId,
      msg.sender,
      block.timestamp,
      block.timestamp + _subscription.timeRange
    );

    subscribers[_currentId] = _subscriber;
    subscriberIndexes[msg.sender] = _currentId;

    return _currentId;
  }

  function renew(
    uint256 _subscriberId,
    uint256 _mldAmount
  ) 
    external 
    payable 
  {
    Subscriber storage _subscriber = subscribers[_subscriberId];
    require(_subscriber.id > 0, "Non existence subscriber");

    Subscription memory _subscription = subscriptions[_subscriber.subscriptionId];
    require(_subscription.id > 0, "Non existed subscription plan");
    require(_mldAmount >= _subscription.priceInMLD, "Not enough MLD");
    require(_currency.balanceOf(msg.sender) >= _subscription.priceInMLD, "Dont have enough MLD");

    // transfer MLD to beneficiary address
    _currency.transfer(_beneficiary, _mldAmount);

    // update _subscriber
    _subscriber.subscribeTime = block.timestamp;
    _subscriber.endTime = block.timestamp + _subscription.timeRange;
  }

}
