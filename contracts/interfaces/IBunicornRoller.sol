// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IBunicornRoller {
    function mintOneRandomBunicornWithStar(
        address minter,
        uint8 stars,
        uint256 randomSeed
    ) external returns(uint256);

    function mintOneRandomBunicornWithStarsProbSpecs(
        address minter,
        uint256 starsProbSpecs,
        uint256 randomSeed
    ) external returns(uint256);

    function mintOneRandomBunicornWithElementAndStarsProbSpecs(
        address minter,
        uint8 element,
        uint256 starsProbSpecs,
        uint256 randomSeed
    ) external returns(uint256);

    function mintOneRandomEventBunicornWithElementAndStarsProbSpecs(
        address minter,
        uint8 element,
        uint256 starsProbSpecs,
        uint256 randomSeed,
        uint16 _eventId
    ) external returns(uint256);

    function mintOneRandomBunicornWithStarAndElement(
        address minter,
        uint8 stars,
        uint8 element,
        uint256 randomSeed
    ) external returns(uint256);

    function mintOneRandomEventBunicornWithStarAndElement(
        address minter,
        uint8 stars,
        uint8 element,
        uint256 randomSeed,
        uint16 _eventId
    ) external returns(uint256);

    function rollAttributesFromStars(
        uint8 _stars,
        uint256 _seed
    ) external returns (uint16, uint16, uint16);
}
