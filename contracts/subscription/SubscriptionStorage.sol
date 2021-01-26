//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "../MelondeAccessControl.sol";

contract SubscriptionStorage is MelondeAccessControl {

  event SubscriptionCreated(
    uint256 id,
    string package,
    uint256 timeRange,
    uint256 priceInMLD
  );

  event SubscriberCreated(
    uint256 id,
    uint256 subscriptionId,
    address subscriber,
    uint256 subscribeTime,
    uint256 endTime
  );

  struct Subscription {
    uint256 id;
    string package;
    uint256 timeRange;
    uint256 priceInMLD;
  }

  struct Subscriber {
    uint256 id;
    uint256 subscriptionId;
    address subscriber;
    uint256 subscribeTime;
    uint256 endTime;
  }

  mapping(uint256 => Subscription) internal subscriptions;
  mapping(uint256 => Subscriber) internal subscribers;
  mapping(address => uint256) internal subscriberIndexes;
}
