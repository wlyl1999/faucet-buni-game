import { ethers, network, upgrades } from "hardhat";
import { getContracts, saveContract } from "./util";
async function main() {
    const networkName = network.name;
    const addresses = getContracts()[networkName];
    const buniAddress = addresses["Buni"];
    const burAddress = addresses["Bur"];
    const gachaAddress = addresses["Gacha"];
    const trainerRollerAddress = addresses["TrainerRoller"];
    const bunicornRollerAddress = addresses["BunicornRoller"];
    console.log(`Deploying FaucetBuniContract`);
    const FaucetContract = await ethers.getContractFactory("FaucetBuniGame");
    const faucetContract = await upgrades.deployProxy(FaucetContract, [bunicornRollerAddress, trainerRollerAddress, buniAddress, burAddress, gachaAddress]);
    await faucetContract.deployed();
    console.log(`Deploy Faucet contract at address ${faucetContract.address}`);
    await saveContract(networkName, "Faucet", faucetContract.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.log(error);
        process.exit(1);
})