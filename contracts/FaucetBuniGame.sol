//SPDX-License-Identifier: Unlicense
pragma solidity 0.6.12;

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";

import "./interfaces/IBunicornRoller.sol";
import "./interfaces/ITrainerRoller.sol";
import "./interfaces/IBurToken.sol";
import "./interfaces/IBuniToken.sol";
import "./interfaces/IGachaToken.sol";

contract  FaucetBuniGame is Initializable, AccessControlUpgradeable {
    using SafeMathUpgradeable for uint256;
    using SafeMathUpgradeable for uint8;

    IBunicornRoller public bunicornRoller;
    mapping (address => uint8) public numberOfMintedBunicorn;
    uint8 public maxMintedBunicorn = 10;

    ITrainerRoller public trainerRoller;
    mapping(address => uint8) public numberOfMintedTrainer;
    uint8 public maxMintedTrainer = 10;

    IBurToken public burToken;
    mapping(address => uint256) public numberOfMintedBur;
    uint256 public maxMintedBur = 10000 ether;

    IBuniToken public buniToken;
    mapping(address => uint256) public numberOfMintedBuni;
    uint256 public maxMintedBuni = 10000 ether;

    IGachaToken public gachaToken;
    mapping(address => uint256) public numberOfMintedGacha;
    uint256 public maxMintedGacha = 100;

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
        ITrainerRoller _trainerRoller,
        IBuniToken _buniToken,
        IBurToken _burToken,
        IGachaToken _gachaToken
    ) public initializer {
        __AccessControl_init();
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ROLE_ADMIN, msg.sender);

        bunicornRoller = _bunicornRoller;
        trainerRoller = _trainerRoller;
        buniToken = _buniToken;
        burToken = _burToken;
        gachaToken = _gachaToken;
    }

    function setMaxBuniMinted(uint256 _maxMintedBuni) public onlyAdmin {
        maxMintedBuni = _maxMintedBuni;
    }

    function setMaxBurMinted(uint256 _maxMintedBur) public onlyAdmin {
        maxMintedBur = _maxMintedBur;
    }

    function setMaxGachaMinted(uint256 _maxMintedGacha) public onlyAdmin {
        maxMintedGacha = _maxMintedGacha;
    }

    function setMaxTrainerMinted(uint8 _maxMintedTrainer) public onlyAdmin {
        maxMintedTrainer = _maxMintedTrainer;
    }

    function setMaxBunicornMinted(uint8 _maxMintedBunicorn) public onlyAdmin {
        maxMintedBunicorn = _maxMintedBunicorn;
    }

    function setEmergencyPause(bool _isEmergencyPause) public onlyAdmin {
        require(_isEmergencyPause != isEmergencyPause, 'Same value');
        isEmergencyPause = _isEmergencyPause;
    }

    function mintBunicorn(uint8 quantity) public notInEmergencyPause {
        require(numberOfMintedBunicorn[msg.sender].add(quantity) <= maxMintedBunicorn, "Too much bunicorns");
        for (uint8 i = 0; i < quantity; i++) {
            uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, i + numberOfMintedBunicorn[msg.sender])));
            uint8 star = uint8(seed % 5);
            bunicornRoller.mintOneRandomBunicornWithStar(msg.sender, star, seed);
        }
        numberOfMintedBunicorn[msg.sender] += quantity;
    }

    function mintTrainer(uint8 quantity) public notInEmergencyPause {
        require(numberOfMintedTrainer[msg.sender].add(quantity) <= maxMintedTrainer, "Too much trainers");
        for (uint8 i = 0; i < quantity; i++) {
            uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, i + numberOfMintedTrainer[msg.sender])));
            uint8 element = uint8(seed % 4);
            uint8 level = uint8(uint256(keccak256(abi.encodePacked(gasleft(), seed))) % 50);
            ITrainersV2 trainersContract = trainerRoller.getTrainersContract();
            trainersContract.mintOneTrainerBySpecsByAdmin(msg.sender, element, level);
        }
        numberOfMintedTrainer[msg.sender] += quantity;
    }

    function mintBur(uint256 quantity) public notInEmergencyPause {
        require(numberOfMintedBur[msg.sender].add(quantity) <= maxMintedBur, "Too much bur");
        burToken.mint(msg.sender, quantity);
        numberOfMintedBur[msg.sender] += quantity;
    }

    function mintBuni(uint256 quantity) public notInEmergencyPause {
        require(numberOfMintedBuni[msg.sender].add(quantity) <= maxMintedBuni, "Too much buni");
        buniToken.mint(msg.sender, quantity);
        numberOfMintedBuni[msg.sender] += quantity;
    }

    function mintGacha(uint256 quantity) public notInEmergencyPause {
        require(numberOfMintedGacha[msg.sender].add(quantity) <= maxMintedGacha, "Too much gacha");
        gachaToken.mint(msg.sender, quantity);
        numberOfMintedGacha[msg.sender] += quantity;
    }
}