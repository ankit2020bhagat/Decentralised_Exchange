

const { run } = require("hardhat");
const hre = require("hardhat");

async function main() {
  const exchangeConrtract = await hre.ethers.getContractFactory("Exchange");
  const deployeContract = await exchangeConrtract.deploy("0x5FbDB2315678afecb367f032d93F642f64180aa3");
  await deployeContract.deployed();
  console.log("Contract Address:", deployeContract.address);
  await deployeContract.deployTransaction.wait(5);
  await verify(deployeContract.address, ["0x5FbDB2315678afecb367f032d93F642f64180aa3"]);
}

async function verify(contractAddress, args) {
  console.log("Verifying Contract....")
  try {
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    })
  } catch (e) {
    if (e.message.toLowerCase().includes("already verified")) 
    console.log("Already veriffied")
    else{
      console.log(e);
    }
    
  }

}


const runMain = async () => {
  try {
    await main();
    process.exit(0);
  }
  catch (error) {
    console.log(error)
    process.exit(1);
  }
}

runMain();

//0x370EDB83b8097E3CdF4755Db2584DE27D33010F0
//0x5FbDB2315678afecb367f032d93F642f64180aa3