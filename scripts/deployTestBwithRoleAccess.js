// eslint-disable-next-line no-unused-vars
/* global ethers */
/* eslint prefer-const: "off" */
const { ethers } = require('hardhat')
const { getSelectors, FacetCutAction } = require('./libraries/diamond.js')

async function deployTestBWithRoleAccess () {
  const TestBWithRoleAccess = await ethers.getContractFactory('TestBWithRoleAccess')
  const testBWithRoleAccess = await TestBWithRoleAccess.deploy('0x5De912f8f9a17d98187e3Fed1e58E179D8D35465')
  await testBWithRoleAccess.deployed()
  console.log('TestBWithRoleAccess deployed:', testBWithRoleAccess.address)

  const cut = []

  cut.push({
    facetAddress: testBWithRoleAccess.address,
    action: FacetCutAction.Add,
    functionSelectors: getSelectors(testBWithRoleAccess)
  })

  // upgrade diamond with facets
  console.log('')
  console.log('Diamond Cut:', cut)
  const diamondCut = await ethers.getContractAt('IDiamondCut', '0x3C87B235Af7944bc3C2d93E65566E5d2e24a070e') // Diamond address
  const diamondInit = await ethers.getContractAt('DiamondInit', '0x42E748c029106Dc366215db2afcc0Aa0480375fD') // DiamondInit address
  let tx
  let receipt
  // call to init function
  let functionCall = diamondInit.interface.encodeFunctionData('init')
  tx = await diamondCut.diamondCut(cut, '0x42E748c029106Dc366215db2afcc0Aa0480375fD', functionCall) // DiamondInit address
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
