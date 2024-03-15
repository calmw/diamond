// eslint-disable-next-line no-unused-vars
/* global ethers */
/* eslint prefer-const: "off" */
const { ethers } = require('hardhat')
const { getSelectors, FacetCutAction } = require('./libraries/diamond.js')

async function deployTestBWithRoleAccess () {
  const TestCWithRoleAccess = await ethers.getContractFactory('TestCWithRoleAccess')
  const testCWithRoleAccess = await TestCWithRoleAccess.deploy()
  await testCWithRoleAccess.deployed()
  console.log('TestCWithRoleAccess deployed:', testCWithRoleAccess.address)

  const cut = []

  cut.push({
    facetAddress: testCWithRoleAccess.address,
    action: FacetCutAction.Add,
    functionSelectors: getSelectors(testCWithRoleAccess)
  })

  // upgrade diamond with facets
  console.log('')
  console.log('Diamond Cut:', cut)
  const diamondCut = await ethers.getContractAt('IDiamondCut', '0xFDf730db30A8690749eb3dCe38D565bD2Ae61D17') // Diamond address
  const diamondInit = await ethers.getContractAt('DiamondInit', '0x9F9470f40E854c0083f3b3239b1101eb19dC18f3') // DiamondInit address
  let tx
  let receipt
  // call to init function
  let functionCall = diamondInit.interface.encodeFunctionData('init')
  tx = await diamondCut.diamondCut(cut, '0x9F9470f40E854c0083f3b3239b1101eb19dC18f3', functionCall) // DiamondInit address
  console.log('Diamond cut tx: ', tx.hash)
  receipt = await tx.wait()
  if (!receipt.status) {
    throw Error(`Diamond upgrade failed: ${tx.hash}`)
  }
  console.log('Completed diamond cut')
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  deployTestBWithRoleAccess()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployTestBWithRoleAccess = deployTestBWithRoleAccess
