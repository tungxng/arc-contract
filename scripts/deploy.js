const hre = require("hardhat");

async function main() {
  const signers = await hre.ethers.getSigners();
  
  if (signers.length === 0) {
    console.error("Error: No accounts found!");
    console.error("Please make sure:");
    console.error("1. You have set PRIVATE_KEY in .env file");
    console.error("2. The network configuration is correct");
    console.error("3. For local network, run 'npm run node' first");
    process.exit(1);
  }

  const deployer = signers[0];
  console.log("Deploying contracts with the account:", deployer.address);
  
  // Check network
  try {
    const network = await hre.ethers.provider.getNetwork();
    console.log("Network:", network.name, "Chain ID:", network.chainId.toString());
  } catch (error) {
    console.log("Warning: Could not get network info:", error.message);
  }
  
  // Get balance with error handling
  try {
    const balance = await deployer.provider.getBalance(deployer.address);
    console.log("Account balance:", hre.ethers.formatEther(balance), "ETH");
    
    if (balance === 0n) {
      console.warn("Warning: Account balance is 0. Make sure you have funds to deploy!");
    }
  } catch (error) {
    console.log("Warning: Could not fetch balance:", error.message);
  }

  // Deploy GM Contract
  console.log("\nDeploying GMContract...");
  const GMContract = await hre.ethers.getContractFactory("GMContract");
  const gmContract = await GMContract.deploy();
  await gmContract.waitForDeployment();
  const gmAddress = await gmContract.getAddress();
  console.log("GMContract deployed to:", gmAddress);

  // Deploy ERC20 Token Factory
  console.log("\nDeploying ERC20TokenFactory...");
  const ERC20TokenFactory = await hre.ethers.getContractFactory("ERC20TokenFactory");
  const tokenFactory = await ERC20TokenFactory.deploy();
  await tokenFactory.waitForDeployment();
  const tokenFactoryAddress = await tokenFactory.getAddress();
  console.log("ERC20TokenFactory deployed to:", tokenFactoryAddress);

  // Deploy NFT Factory
  console.log("\nDeploying NFTFactory...");
  const NFTFactory = await hre.ethers.getContractFactory("NFTFactory");
  const nftFactory = await NFTFactory.deploy();
  await nftFactory.waitForDeployment();
  const nftFactoryAddress = await nftFactory.getAddress();
  console.log("NFTFactory deployed to:", nftFactoryAddress);

  console.log("\n=== Deployment Summary ===");
  console.log("GMContract:", gmAddress);
  console.log("ERC20TokenFactory:", tokenFactoryAddress);
  console.log("NFTFactory:", nftFactoryAddress);
  console.log("\nSave these addresses for your frontend integration!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

