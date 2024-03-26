
const { ethers } = require('hardhat')

async function deployRoleAccess () {
  // deploy DiamondCutFacet
  const RoleAccess = await ethers.getContractFactory('RoleAccessOld.sol')
  const roleAccess = await RoleAccess.deploy()
  await roleAccess.deployed()
  console.log('RoleAccessOld.sol deployed:', roleAccess.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  deployRoleAccess()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployRoleAccess = deployRoleAccess
