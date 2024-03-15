#### 使用hardhat部署DiamondWithRoleAccess

``` shell
npx hardhat --network match_test run scripts/deploy.js

#  
DiamondCutFacet deployed: 0x9177BB423A9f9991EA4aF6A3ca84Afa5D30866b1
Diamond deployed: 0xFDf730db30A8690749eb3dCe38D565bD2Ae61D17
DiamondInit deployed: 0x9F9470f40E854c0083f3b3239b1101eb19dC18f3

Deploying facets
DiamondLoupeFacet deployed: 0x18F5C32Db9A0993c6394F4D6089a5DcA468D9111
OwnershipFacet deployed: 0x5BD079d631F088B0D9016631dbC1c6Ac1dd136d4


```


#### 部署TestCWithRoleAccess进行测试

``` shell
npx hardhat --network match_test run scripts/deployTestCwithRoleAccess.js
#
TestCWithRoleAccess deployed: 0x792b0ECB1D7fA7489788616A530F60b069afEAbc



```