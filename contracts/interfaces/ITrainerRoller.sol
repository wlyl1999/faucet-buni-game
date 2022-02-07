pragma solidity 0.6.12;

import "./v2.0/ITrainersV2.sol";

interface ITrainerRoller {
    function mintOneRandomTrainer(address minter, uint256 _randomSeed) external;
    function getTrainersContract() external view returns (ITrainersV2 _trainersContract);
}