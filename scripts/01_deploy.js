const hre = require("hardhat");

async function main() {
  const MelondyFactory = await hre.ethers.getContractFactory("Melonde");
  const melondy = await MelondyFactory.deploy();

  await melondy.deployed();

  console.log("Melonde deployed to:", melondy.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
