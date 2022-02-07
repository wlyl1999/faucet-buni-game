// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface ITrainersV2 {
    // read
    // function getTotalTrainers() external view returns(uint256);
    
    // write
    function mintOneTrainerBySpecs(address _minter, uint8 _element) external;
    function mintOneTrainerBySpecsByAdmin(address _minter, uint8 _element, uint8 _level) external;
    // function mintByMigrator(address _tokenOwner, uint8 _element, uint16 _exp, uint8 _level, uint8 _fusionLevel) external;
    function burnByGameContract(uint256 _trainerId) external;
}