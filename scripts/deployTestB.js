// eslint-disable-next-line no-unused-vars
/* global ethers */
/* eslint prefer-const: "off" */
const { ethers } = require('hardhat')
const { getSelectors, FacetCutAction } = require('./libraries/diamond.js')

async function deployTestA () {
  // deploy DiamondCutFacet
  const TestB = await ethers.getContractFactory('TestB')
  const testB = await TestB.deploy()
  await testB.deployed()
  console.log('testB deployed:', testB.address)

  // deploy facets
  console.log('')
  console.log('Deploying facets')

  const cut = []

  cut.push({
    facetAddress: testB.address,
    action: FacetCutAction.Add,
    functionSelectors: getSelectors(testB)
  })

  // upgrade diamond with facets
  console.log('')
  console.log('Diamond Cut:', cut)
  const diamondCut = await ethers.getContractAt('IDiamondCut', '0x4fB55EA66C026aAA8c36C6FBd5837eBF495d6841')
  const diamondInit = await ethers.getContractAt('DiamondInit', '0x22Ff9ee034868A8a9712f2670C60bc2b4e9e02E3')
  let tx
  let receipt
  // call to init function
  let functionCall = diamondInit.interface.encodeFunctionData('init')
  tx = await diamondCut.diamondCut(cut, '0x22Ff9ee034868A8a9712f2670C60bc2b4e9e02E3', functionCall)
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
  deployTestA()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployTestA = deployTestA
