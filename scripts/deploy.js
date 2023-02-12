
const hre = require("hardhat");

async function main() {
  const exchangeConrtract  = await hre.ethers.getContractFactory("Exchange");
  const deployeContract = await exchangeConrtract.deploy();
  await deployeContract.deployed();
  console.log("Contract Address:",deployeContract.address);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
