const hre = require("hardhat");

async function main() {
  const initialSupply = hre.ethers.parseUnits("1000", 18); // 1000 token với 18 số thập phân
  const MyToken = await hre.ethers.getContractFactory("MyToken");
  const myToken = await MyToken.deploy(initialSupply);

  await myToken.waitForDeployment();
  await myToken.transfer(
    "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
    ethers.parseUnits("100", 18)
  ); // Gửi 100 token
  console.log("MyToken deployed to:", myToken.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
