#### 使用hardhat部署Diamond

``` shell
npx hardhat --network match_test run scripts/deploy.js

#  
DiamondCutFacet deployed: 0xd5319d0DA55C797c9EA152921d3513B80a1c0e6a
Diamond deployed: 0x3C87B235Af7944bc3C2d93E65566E5d2e24a070e
DiamondInit deployed: 0x42E748c029106Dc366215db2afcc0Aa0480375fD

Deploying facets
DiamondLoupeFacet deployed: 0x45Ee32c82839F79D2cE122d8c6D53741167e31AA
OwnershipFacet deployed: 0xB7CD3e207378131EFa73c0E5dB0C419DB417b578


```

#### 部署权限合约

``` shell
npx hardhat --network match_test run scripts/deployRoleAccess.js
#
RoleAccess deployed: 0x5De912f8f9a17d98187e3Fed1e58E179D8D35465
```

#### 部署TestBWithRoleAccess进行测试

``` shell
npx hardhat --network match_test run scripts/deployTestBwithRoleAccess.js
#
TestBWithRoleAccess deployed: 0x0b58D349F3d2e5a0876E9484BeA07575643956B3


```