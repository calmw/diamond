
// eslint-disable-next-line no-unused-vars
require('@nomiclabs/hardhat-waffle')

const prk = process.env.HUZHI_SOCIAL_MEDIA

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.6',
  settings: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  },
  networks: {
    match_test: {
      url: 'https://lisbon-testnet-rpc.matchtest.co',
      accounts: [prk]
    }
  }
}
