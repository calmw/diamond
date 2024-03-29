# EIP2535的实现: diamond

- 使用diamond有多种不同的原因。这里是其中的一些：
    - 单一地址可实现无限合约功能。使用单一地址来实现合约功能可以使部署、测试以及与其他智能合约、软件和用户界面的集成变得更加容易。
    - 您的合约超出了 24KB 最大合约大小。您可能具有将其保留在单个合约或单个合约地址中有意义的相关功能。diamond没有最大合约大小。
    - diamond提供了一种组织合约代码和数据的方法。您可能想要构建一个具有很多功能的合约系统。diamond提供了一种系统的方法来隔离不同的功能，并将它们连接在一起，并根据需要以高效的方式在它们之间共享数据。
    - diamond提供了一种升级功能的方法。可升级diamond可以升级以添加/替换/删除功能。由于diamond没有最大合约大小，因此随着时间的推移，可以添加到diamond的功能数量没有限制。
    - diamond可以升级，而无需重新部署现有功能。可以添加/替换/删除diamond的某些部分，同时保留其他部分。
    - diamond可以是不可变的。稍后可以部署不可变diamond或使可升级diamond不可变。
    - diamond可以重复使用已部署的合约。无需将合约部署到区块链，现有的已部署链上合约可用于创建diamond。可以根据现有部署的合同创建定制diamond。这使得创建链上智能合约平台和库成为可能。

## 架构

- EIP 2535 提议使用：
    - 1 与实现合约适配的查找表（lookup table）
    - 2 任意的存储指针（arbitrary storage pointer）

## 使用

- 部署diamond [deploy.md](docs/deploy/deploy.md)
- 部署带权限的diamond ,权限合约单独部署 [deploy.md](docs/deploy_with_access/deploy.md)
- 部署带权限的diamond ,权限功能放在diamond中一起部署 [deploy.md](docs/deploy_with_access/deploy_with_accress.md)
