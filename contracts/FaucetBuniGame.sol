//SPDX-License-Identifier: Unlicense
pragma solidity 0.6.12;

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";

import "./interfaces/IBunicornRoller.sol";
import "./interfaces/ITrainerRoller.sol";

contract  FaucetBuniGame is Initializable, AccessControlUpgradeable {
    using SafeMathUpgradeable for uint256;

    IBunicornRoller public bunicornRoller;
    mapping (address => uint8) public numberOfMintedBunicorn;
    uint8 public maxMintedBunicorn = 10;

    ITrainerRoller public trainerRoller;
    mapping(address => uint8) public numberOfMintedTrainer;
    uint8 public maxMintedTrainer = 10;

    bool public isEmergencyPause;
    bytes32 public constant ROLE_ADMIN = keccak256("ROLE_ADMIN");
    
    modifier notInEmergencyPause() {
        require(!isEmergencyPause, 'emergency pause');
        _;
    }

    modifier onlyAdmin() {
        require(hasRole(ROLE_ADMIN, msg.sender), "Not game admin");
        _;
    }

    function initialize(
        IBunicornRoller _bunicornRoller,
        ITrainerRoller _trainerRoller
    ) public initializer {
        __AccessControl_init();
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ROLE_ADMIN, msg.sender);

        bunicornRoller = _bunicornRoller;
        trainerRoller = _trainerRoller;
    }

    function mintBunicorn(uint8 quantity) public {
        require(quantity <= maxMintedBunicorn, "Too much bunicorns");
        require(numberOfMintedBunicorn[msg.sender] <= maxMintedBunicorn - quantity, "Too much bunicorns");
        for (uint8 i = 0; i < quantity; i++) {
            uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, i + numberOfMintedBunicorn[msg.sender])));
            uint8 star = uint8(seed % 5);
            bunicornRoller.mintOneRandomBunicornWithStar(msg.sender, star, seed);
        }
        numberOfMintedBunicorn[msg.sender] += quantity;
    }

    function mintTrainer(uint8 quantity) public {
        require(quantity <= maxMintedTrainer, "Too much trainers");
        require(numberOfMintedTrainer[msg.sender] <= maxMintedTrainer - quantity, "Too much trainers");
        for (uint8 i = 0; i < quantity; i++) {
            uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, i + numberOfMintedTrainer[msg.sender])));
            uint8 element = uint8(seed % 4);
            uint8 level = uint8(uint256(keccak256(abi.encodePacked(gasleft(), seed))) % 20);
            ITrainersV2 trainersContract = trainerRoller.getTrainersContract();
            trainersContract.mintOneTrainerBySpecsByAdmin(msg.sender, element, level);
        }
        numberOfMintedTrainer[msg.sender] += quantity;
    }
}