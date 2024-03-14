// eslint-disable-next-line no-unused-vars
/* global ethers */
/* eslint prefer-const: "off" */
const { ethers } = require('hardhat')
const { getSelectors, FacetCutAction } = require('./libraries/diamond.js')

async function deployTestA () {
  // deploy DiamondCutFacet
  const TestA = await ethers.getContractFactory('TestA')
  const testA = await TestA.deploy()
  await testA.deployed()
  console.log('TestA deployed:', testA.address)

  // deploy facets
  console.log('')
  console.log('Deploying facets')

  const cut = []

  cut.push({
    facetAddress: testA.address,
    action: FacetCutAction.Add,
    functionSelectors: getSelectors(testA)
  })

  // upgrade diamond with facets
  console.log('')
  console.log('Diamond Cut:', cut)
  const diamondCut = await ethers.getContractAt('IDiamondCut', '0x48f21CC76Edc7ACA45A28248B3E9999b7ae1232C')
  const diamondInit = await ethers.getContractAt('DiamondInit', '0xfeB3bdA4910ad77a9135E2b0674F53E1D7F94453')
  let tx
  let receipt
  // call to init function
  let functionCall = diamondInit.interface.encodeFunctionData('init')
  tx = await diamondCut.diamondCut(cut, '0xfeB3bdA4910ad77a9135E2b0674F53E1D7F94453', functionCall)
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
