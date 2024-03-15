#### 使用hardhat部署Diamond

``` shell
npx hardhat --network match_test run scripts/deploy.js

#
DiamondCutFacet deployed: 0x7FF1914FFA3Dc3F0757E6C21A51552B95880F21A
Diamond deployed: 0x4fB55EA66C026aAA8c36C6FBd5837eBF495d6841
DiamondInit deployed: 0x22Ff9ee034868A8a9712f2670C60bc2b4e9e02E3

Deploying facets
DiamondLoupeFacet deployed: 0xFBC3B838493c4f7f342eC6cF194a3a9CAde37211
OwnershipFacet deployed: 0xF09CE24adf853C29a7E31a7C15B1533cB5b6555c

Diamond Cut: [
  {
    facetAddress: '0xFBC3B838493c4f7f342eC6cF194a3a9CAde37211',
    action: 0,
    functionSelectors: [
      '0xcdffacc6',
      '0x52ef6b2c',
      '0xadfca15e',
      '0x7a0ed627',
      '0x01ffc9a7',
      contract: [Contract],
      remove: [Function: remove],
      get: [Function: get]
    ]
  },
  {
    facetAddress: '0xF09CE24adf853C29a7E31a7C15B1533cB5b6555c',
    action: 0,
    functionSelectors: [
      '0x8da5cb5b',
      '0xf2fde38b',
      contract: [Contract],
      remove: [Function: remove],
      get: [Function: get]
    ]
  }
]
Diamond cut tx:  0x5d549965da39d63c286ae808a8606f429149cc80eb8d602e05f2237921381024
Completed diamond cut

```

#### 部署自己合约进行测试

``` shell
npx hardhat --network match_test run scripts/deployTestA.js

#
TestA deployed: 0x40445F6A00ed0D9b9b42F471f5ef44De9dC063C5

```