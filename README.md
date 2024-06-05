![alt text](header.png)

# Rainbow Road Contracts

## Getting Started

1. Install packages

```
npm install
```

2. Compile contracts

```
npx hardhat compile
```

3. Run tests

```
TS_TRANSPILE_NODE=1 npx hardhat test
```

## Setup environment variables

We are going to use the [`@chainlink/env-enc`](https://www.npmjs.com/package/@chainlink/env-enc) package for extra security. It encrypts sensitive data instead of storing them as plain text in the `.env` file, by creating a new, `.env.enc` file. Although it's not recommended to push this file online, if that accidentally happens your secrets will still be encrypted.

1. Set a password for encrypting and decrypting the environment variable file. You can change it later by typing the same command.

```shell
npx env-enc set-pw
```

2. Now set the following environment variables: `PRIVATE_KEY`, Source Blockchain RPC URL, Destination Blockchain RPC URL. You can see available options in the `.env.example` file:

```shell
ETHEREUM_SEPOLIA_RPC_URL=""
OPTIMISM_GOERLI_RPC_URL=""
ARBITRUM_TESTNET_RPC_URL=""
AVALANCHE_FUJI_RPC_URL=""
POLYGON_MUMBAI_RPC_URL=""
```

To set these variables, type the following command and follow the instructions in the terminal:

```shell
npx env-enc set
```

After you are done, the `.env.enc` file will be automatically generated.

If you want to validate your inputs you can always run the next command:

```shell
npx env-enc view
```

### Rainbow Road Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | [0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9](https://nova.arbiscan.io/address/0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9#code) |
| Arbitrum One | [0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9](https://arbiscan.io/address/0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9#code) |
| Avalanche | [0x9412316DC6C882ffc4FA1A01413b0C701b147B9E](https://snowtrace.io/address/0x9412316DC6C882ffc4FA1A01413b0C701b147B9E#code) |
| Base | [0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9](https://basescan.org/address/0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9#code) |
| BNB Chain | [0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9](https://bscscan.com/address/0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9#code) |
| Cronos | [0x9412316DC6C882ffc4FA1A01413b0C701b147B9E](https://cronoscan.com/address/0x9412316dc6c882ffc4fa1a01413b0c701b147b9e#code) |
| Fantom | [0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9](https://ftmscan.com/address/0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9#code) |
| Kava | [0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9](https://kavascan.com/address/0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9/contracts) |
| Mantle | [0x9412316DC6C882ffc4FA1A01413b0C701b147B9E](https://explorer.mantle.xyz/address/0x9412316DC6C882ffc4FA1A01413b0C701b147B9E/contracts) |
| Metis | [0x9412316DC6C882ffc4FA1A01413b0C701b147B9E](https://explorer.metis.io/address/0x9412316DC6C882ffc4FA1A01413b0C701b147B9E/contract/1088/code) |
| Neon | [0x9412316DC6C882ffc4FA1A01413b0C701b147B9E](https://neonscan.org/address/0x9412316dc6c882ffc4fa1a01413b0c701b147b9e#contract) |
| Optimism | [0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9](https://optimistic.etherscan.io/address/0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9#code) |
| Polygon | [0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9](https://polygonscan.com/address/0x9DE5b4928296D96f48Fe67ebB2cA1556827fc6A9#code) |
| Telos | [0xfC775F6D51DF10c56bF653aE592c7904598dc35E](https://www.teloscan.io/address/0xfC775F6D51DF10c56bF653aE592c7904598dc35E#contract) |
| zkSync Era | [0xEb484dddfAD4F89c0F72267c7d13752451831038](https://explorer.zksync.io/address/0xEb484dddfAD4F89c0F72267c7d13752451831038#contract) |

### Fee Collector Factory Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | [0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17](https://nova.arbiscan.io/address/0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17#code) |
| Arbitrum One | [0xf693C2018DF28123533B1f7840ffb9a3102585C0](https://arbiscan.io/address/0xf693C2018DF28123533B1f7840ffb9a3102585C0#code) |
| Avalanche | [0xb17906D2C9F0457492077D2952f0cA333Fe70B6F](https://snowtrace.io/address/0xb17906D2C9F0457492077D2952f0cA333Fe70B6F#code) |
| Base | [0xf693C2018DF28123533B1f7840ffb9a3102585C0](https://basescan.org/address/0xf693C2018DF28123533B1f7840ffb9a3102585C0#code) |
| BNB Chain | [0xf693C2018DF28123533B1f7840ffb9a3102585C0](https://bscscan.com/address/0xf693C2018DF28123533B1f7840ffb9a3102585C0#code) |
| Cronos | [0xb17906D2C9F0457492077D2952f0cA333Fe70B6F](https://cronoscan.com/address/0xb17906d2c9f0457492077d2952f0ca333fe70b6f#code) |
| Fantom | [0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17](https://ftmscan.com/address/0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17#code) |
| Kava | [0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17](https://kavascan.com/address/0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17/contracts) |
| Mantle | [0xb17906D2C9F0457492077D2952f0cA333Fe70B6F](https://explorer.mantle.xyz/address/0xb17906D2C9F0457492077D2952f0cA333Fe70B6F/contracts) |
| Metis | [0xb17906D2C9F0457492077D2952f0cA333Fe70B6F](https://explorer.metis.io/address/0xb17906D2C9F0457492077D2952f0cA333Fe70B6F/contract/1088/code) |
| Neon | [0xb17906D2C9F0457492077D2952f0cA333Fe70B6F](https://neonscan.org/address/0xb17906d2c9f0457492077d2952f0ca333fe70b6f#contract) |
| Optimism | [0xB98D4D0Ed40b47Ded99c9B17cE89C9bF09F22Ee3](https://optimistic.etherscan.io/address/0xB98D4D0Ed40b47Ded99c9B17cE89C9bF09F22Ee3#code) |
| Polygon | [0xB98D4D0Ed40b47Ded99c9B17cE89C9bF09F22Ee3](https://polygonscan.com/address/0xB98D4D0Ed40b47Ded99c9B17cE89C9bF09F22Ee3#code) |
| Telos | [0x523073f029C889242beBFbB7eE3BDaB52942a39A](https://www.teloscan.io/address/0x523073f029C889242beBFbB7eE3BDaB52942a39A#contract) |
| zkSync Era | [0xBfDDBD9F71d2FB88923e0a7Fb06a5aa937D9F5fF](https://explorer.zksync.io/address/0xBfDDBD9F71d2FB88923e0a7Fb06a5aa937D9F5fF#contract) |

### ERC20 Transfer Handler Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | [0x16b5856DBC2F66d6Dc5B361B0073f51ed5FfB52b](https://nova.arbiscan.io/address/0x16b5856DBC2F66d6Dc5B361B0073f51ed5FfB52b#code) |
| Arbitrum One | [0x600aF6290ca77d39b9D111e30FE5f9A6AF3aE2FC](https://arbiscan.io/address/0x600aF6290ca77d39b9D111e30FE5f9A6AF3aE2FC#code) |
| Avalanche | [0x8E4dd1749dfD63538Ca3ceF29b10f9E25605A4cc](https://snowtrace.io/address/0x8E4dd1749dfD63538Ca3ceF29b10f9E25605A4cc#code) |
| Base | [0x724f9A247A6755d5Fd93e0cf1e563F9441523618](https://basescan.org/address/0x724f9A247A6755d5Fd93e0cf1e563F9441523618#code) |
| BNB Chain | [0xc20b717E273adB4099Cd455376e24e33AcB30C07](https://bscscan.com/address/0xc20b717E273adB4099Cd455376e24e33AcB30C07#code) |
| Cronos | [0x8E4dd1749dfD63538Ca3ceF29b10f9E25605A4cc](https://cronoscan.com/address/0x8e4dd1749dfd63538ca3cef29b10f9e25605a4cc#code) |
| Fantom | [0xb7A6501716C7930270F5634953862053B4227100](https://ftmscan.com/address/0xb7A6501716C7930270F5634953862053B4227100#code) |
| Kava | [0xEec547122f5EA2Edb34D46114c9c6A7c896f5041](https://kavascan.com/address/0xEec547122f5EA2Edb34D46114c9c6A7c896f5041/contracts) |
| Mantle | [0x8E4dd1749dfD63538Ca3ceF29b10f9E25605A4cc](https://explorer.mantle.xyz/address/0x8E4dd1749dfD63538Ca3ceF29b10f9E25605A4cc/contracts) |
| Metis | [0x8E4dd1749dfD63538Ca3ceF29b10f9E25605A4cc](https://explorer.metis.io/address/0x8E4dd1749dfD63538Ca3ceF29b10f9E25605A4cc/contract/1088/code) |
| Neon | [0x8E4dd1749dfD63538Ca3ceF29b10f9E25605A4cc](https://neonscan.org/address/0x8e4dd1749dfd63538ca3cef29b10f9e25605a4cc#contract) |
| Optimism | [0xdD07Fd54d7a3668018fb731A091A1F7927897424](https://optimistic.etherscan.io/address/0xdD07Fd54d7a3668018fb731A091A1F7927897424#code) |
| Polygon | [0x10dA2d78420cE6FEAFA090663e9d0915Caa041c4](https://polygonscan.com/address/0x10dA2d78420cE6FEAFA090663e9d0915Caa041c4#code) |
| Telos | [0x9194b4F9A8DB883A870fa5Eba998aA4a6DD97e3B](https://www.teloscan.io/address/0x9194b4F9A8DB883A870fa5Eba998aA4a6DD97e3B#contract) |
| zkSync Era | [0x71071F3b894045329D392d2201Fc841e1AB211b8](https://explorer.zksync.io/address/0x71071F3b894045329D392d2201Fc841e1AB211b8#contract) |

### veArc Transfer Handler Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | [0x23f014285814A3c33Ef78F3FA1b1DF96fA63CE23](https://nova.arbiscan.io/address/0x23f014285814A3c33Ef78F3FA1b1DF96fA63CE23#code) |
| Arbitrum One | [0x63442B9ADc73D87fE31D3fE1d5aC45abD5772911](https://arbiscan.io/address/0x63442B9ADc73D87fE31D3fE1d5aC45abD5772911#code) |
| Avalanche | [0xEfBC28a489265Ec91757b243Af6203Baec0B4B00](https://snowtrace.io/address/0xEfBC28a489265Ec91757b243Af6203Baec0B4B00#code) |
| Base | [0x1d3b404a18a83493C6b900E9e7B2cD2761099997](https://basescan.org/address/0x1d3b404a18a83493C6b900E9e7B2cD2761099997#code) |
| BNB Chain | [0x0Ce5A89Fb6E9d41298C0b231bCb90Fb9491a22D7](https://bscscan.com/address/0x0Ce5A89Fb6E9d41298C0b231bCb90Fb9491a22D7#code) |
| Cronos | [0xEfBC28a489265Ec91757b243Af6203Baec0B4B00](https://cronoscan.com/address/0xefbc28a489265ec91757b243af6203baec0b4b00#code) |
| Fantom | [0x30278A2DAECa1088152DA4a216c545c65B1490f8](https://ftmscan.com/address/0x30278A2DAECa1088152DA4a216c545c65B1490f8#code) |
| Kava | [0x01Ce32DF6C7D016C9bf6dce5e07Cb95FA9DF4895](https://kavascan.com/address/0x01Ce32DF6C7D016C9bf6dce5e07Cb95FA9DF4895/contracts) |
| Mantle | [0xEfBC28a489265Ec91757b243Af6203Baec0B4B00](https://explorer.mantle.xyz/address/0xEfBC28a489265Ec91757b243Af6203Baec0B4B00) |
| Metis | [0xEfBC28a489265Ec91757b243Af6203Baec0B4B00](https://explorer.metis.io/address/0xEfBC28a489265Ec91757b243Af6203Baec0B4B00/contract/1088/code) |
| Neon | [0xEfBC28a489265Ec91757b243Af6203Baec0B4B00](https://neonscan.org/address/0xefbc28a489265ec91757b243af6203baec0b4b00#contract) |
| Optimism | [0x708514080FBC9F7cd597571fD5CebFfD2b03dcf5](https://optimistic.etherscan.io/address/0x708514080FBC9F7cd597571fD5CebFfD2b03dcf5#code) |
| Polygon | [0x120b672B7977494Bb64B7b35B158Ff75e5E1f4d4](https://polygonscan.com/address/0x120b672B7977494Bb64B7b35B158Ff75e5E1f4d4#code) |
| Telos | [0xB7d01d3978d2155A9B5c50035dbd89114BE6C203](https://www.teloscan.io/address/0xB7d01d3978d2155A9B5c50035dbd89114BE6C203#contract) |
| zkSync Era | [0xF80adb93165E1dEC3dA4B8F3a9b709b734D26f03](https://explorer.zksync.io/address/0xF80adb93165E1dEC3dA4B8F3a9b709b734D26f03#contract) |

### DEX Weekly Update Handler Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | [0x193A2D15a9A8fA02301116d4f3666619154BEeB7](https://nova.arbiscan.io/address/0x193A2D15a9A8fA02301116d4f3666619154BEeB7#code) |
| Arbitrum One | [0x339dec659aD3ccCB45F298365749AA96a66CD80D](https://arbiscan.io/address/0x339dec659aD3ccCB45F298365749AA96a66CD80D#code) |
| Avalanche | [0x4f91C473655B87D844130785081F55EF422f4ACA](https://snowtrace.io/address/0x4f91C473655B87D844130785081F55EF422f4ACA#code) |
| Base | [0x339dec659aD3ccCB45F298365749AA96a66CD80D](https://basescan.org/address/0x339dec659aD3ccCB45F298365749AA96a66CD80D#code) |
| BNB Chain | [0x339dec659aD3ccCB45F298365749AA96a66CD80D](https://bscscan.com/address/0x339dec659aD3ccCB45F298365749AA96a66CD80D#code) |
| Cronos | [0x4f91C473655B87D844130785081F55EF422f4ACA](https://cronoscan.com/address/0x4f91c473655b87d844130785081f55ef422f4aca#code) |
| Fantom | [0x193A2D15a9A8fA02301116d4f3666619154BEeB7](https://ftmscan.com/address/0x193A2D15a9A8fA02301116d4f3666619154BEeB7#code) |
| Kava | [0x193A2D15a9A8fA02301116d4f3666619154BEeB7](https://kavascan.com/address/0x193A2D15a9A8fA02301116d4f3666619154BEeB7/contracts) |
| Mantle | [0x4f91C473655B87D844130785081F55EF422f4ACA](https://explorer.mantle.xyz/address/0x4f91C473655B87D844130785081F55EF422f4ACA/contracts) |
| Metis | [0x4f91C473655B87D844130785081F55EF422f4ACA](https://explorer.metis.io/address/0x4f91C473655B87D844130785081F55EF422f4ACA/contract/1088/code) |
| Neon | [0x4f91C473655B87D844130785081F55EF422f4ACA](https://neonscan.org/address/0x4f91c473655b87d844130785081f55ef422f4aca#contract) |
| Optimism | [0x339dec659aD3ccCB45F298365749AA96a66CD80D](https://optimistic.etherscan.io/address/0x339dec659aD3ccCB45F298365749AA96a66CD80D#code) |
| Polygon | [0x339dec659aD3ccCB45F298365749AA96a66CD80D](https://polygonscan.com/address/0x339dec659aD3ccCB45F298365749AA96a66CD80D#code) |
| Telos | [0x193A2D15a9A8fA02301116d4f3666619154BEeB7](https://www.teloscan.io/address/0x193A2D15a9A8fA02301116d4f3666619154BEeB7#contract) |
| zkSync Era | [0x0E83A9237E6475eB00eED787edfC711232946156](https://explorer.zksync.io/address/0x0E83A9237E6475eB00eED787edfC711232946156#contract) |

### Chainlink Data Feed Factory Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | [0x3D074Cc110f34fcB4C9FC887f0EB870E99AE4932](https://nova.arbiscan.io/address/0x3D074Cc110f34fcB4C9FC887f0EB870E99AE4932#code) |
| Arbitrum One | [0x0d4DebC10cd99034fa777D84FE158Eb04c2ed4c3](https://arbiscan.io/address/0x0d4DebC10cd99034fa777D84FE158Eb04c2ed4c3#code) |
| Avalanche | TBD |
| Base | TBD |
| BNB Chain | TBD |
| Cronos | [0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F](https://cronoscan.com/address/0x9d1a576ef61e734cd0272a8652fad5a18fb1337f#code) |
| Fantom | TBD |
| Kava | [0x7465aE4fd3Ec52a56A6fd78fB4f4502191BfD60b](https://kavascan.com/address/0x7465aE4fd3Ec52a56A6fd78fB4f4502191BfD60b/contracts) |
| Mantle | [0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F](https://explorer.mantle.xyz/address/0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F/contracts) |
| Metis | [0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F](https://explorer.metis.io/address/0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F/contract/1088/code) |
| Neon | [0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F](https://neonscan.org/address/0x9d1a576ef61e734cd0272a8652fad5a18fb1337f#contract) |
| Optimism | TBD |
| Polygon | TBD |
| Telos | [0x4aCb1Bc3813432311948876102B7542560ee1f25](https://www.teloscan.io/address/0x4aCb1Bc3813432311948876102B7542560ee1f25#contract) |
| zkSync Era | [0x3E21E1CefcDFd8bB668fa2A14485026c20428f41](https://explorer.zksync.io/address/0x3E21E1CefcDFd8bB668fa2A14485026c20428f41#contract) |

### Chainlink Data Feed Handler Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | [0x78bADa77C33EAA3cbF84e6Ad99bccf710345e1ed](https://nova.arbiscan.io/address/0x78bADa77C33EAA3cbF84e6Ad99bccf710345e1ed#code) |
| Arbitrum One | [0x0Ce5A89Fb6E9d41298C0b231bCb90Fb9491a22D7](https://arbiscan.io/address/0x0Ce5A89Fb6E9d41298C0b231bCb90Fb9491a22D7#code) |
| Avalanche | TBD |
| Base | TBD |
| BNB Chain | TBD |
| Cronos | [0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17](https://cronoscan.com/address/0xda25a4e7407b95883d4b038b394bf607ccee4b17#code) |
| Fantom | TBD |
| Kava | [0x2eBdCD5F200B62f2AD8A241fBbCe4df5158A2295](https://kavascan.com/address/0x2eBdCD5F200B62f2AD8A241fBbCe4df5158A2295/contracts) |
| Mantle | [0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17](https://explorer.mantle.xyz/address/0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17/contracts) |
| Metis | [0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17](https://explorer.metis.io/address/0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17/contract/1088/code) |
| Neon | [0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17](https://neonscan.org/address/0xda25a4e7407b95883d4b038b394bf607ccee4b17#contract) |
| Optimism | TBD|
| Polygon | TBD |
| Telos | [0x8a382156Bf6484F6C0ff813acdF809470795CDD0](https://www.teloscan.io/address/0x8a382156Bf6484F6C0ff813acdF809470795CDD0#contract) |
| zkSync Era | [0xbc8D98C4D43a7c14189a4b3A5e7f21e7CB5abFB3](https://explorer.zksync.io/address/0xbc8D98C4D43a7c14189a4b3A5e7f21e7CB5abFB3#contract) |

### Chainlink Receiver Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | TBD |
| Arbitrum One | [0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F](https://arbiscan.io/address/0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F#code) |
| Avalanche | [0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17](https://snowtrace.io/address/0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17#code) |
| Base | [0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F](https://basescan.org/address/0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F#code) |
| BNB Chain | [0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F](https://bscscan.com/address/0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F#code) |
| Cronos | TBD |
| Fantom | TBD |
| Kava | TBD |
| Mantle | TBD |
| Metis | TBD |
| Neon | TBD |
| Optimism | [0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F](https://optimistic.etherscan.io/address/0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F#code) |
| Polygon | [0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F](https://polygonscan.com/address/0x9d1A576EF61e734CD0272a8652Fad5A18FB1337F#code) |
| Telos | TBD |
| zkSync Era | TBD |

### Chainlink Sender Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | TBD |
| Arbitrum One | [0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17](https://arbiscan.io/address/0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17#code) |
| Avalanche | [0xfC775F6D51DF10c56bF653aE592c7904598dc35E](https://snowtrace.io/address/0xfC775F6D51DF10c56bF653aE592c7904598dc35E#code) |
| Base | [0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17](https://basescan.org/address/0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17#code) |
| BNB Chain | [0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17](https://bscscan.com/address/0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17#code) |
| Cronos | TBD |
| Fantom | TBD |
| Kava | TBD |
| Mantle | TBD |
| Metis | TBD |
| Neon | TBD |
| Optimism | [0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17](https://optimistic.etherscan.io/address/0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17#code) |
| Polygon | [0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17](https://polygonscan.com/address/0xDa25A4e7407b95883D4B038b394Bf607CCEE4b17#code) |
| Telos | TBD |
| zkSync Era | TBD |

### Axelar Receiver Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | TBD |
| Arbitrum One | [0x273C9c5766c0c2441d778814c5d68D847c022f00](https://arbiscan.io/address/0x273C9c5766c0c2441d778814c5d68D847c022f00#code) |
| Avalanche | [0xbf9813FC8f99759A77D877F812ff065D2070F1cC](https://snowtrace.io/address/0xbf9813FC8f99759A77D877F812ff065D2070F1cC#code) |
| Base | [0x273C9c5766c0c2441d778814c5d68D847c022f00](https://basescan.org/address/0x273C9c5766c0c2441d778814c5d68D847c022f00#code) |
| BNB Chain | [0x273C9c5766c0c2441d778814c5d68D847c022f00](https://bscscan.com/address/0x273C9c5766c0c2441d778814c5d68D847c022f00#code) |
| Cronos | TBD |
| Fantom | [0x027d732749992c7b12D8c48a08eFCcE9Cb1288BC](https://ftmscan.com/address/0x027d732749992c7b12D8c48a08eFCcE9Cb1288BC#code) |
| Kava | [0xFD7A105225433c05fE0E5851df7AF5C00b245dF8](https://kavascan.com/address/0xFD7A105225433c05fE0E5851df7AF5C00b245dF8/contracts) |
| Mantle | [0x877fe019d5320bc5A1ab6d72f05D13ba8A651350](https://explorer.mantle.xyz/address/0x877fe019d5320bc5A1ab6d72f05D13ba8A651350/contracts) |
| Metis | TBD |
| Neon | TBD |
| Optimism | [0x273C9c5766c0c2441d778814c5d68D847c022f00](https://optimistic.etherscan.io/address/0x273C9c5766c0c2441d778814c5d68D847c022f00#code) |
| Polygon | [0x273C9c5766c0c2441d778814c5d68D847c022f00](https://polygonscan.com/address/0x273C9c5766c0c2441d778814c5d68D847c022f00#code) |
| Telos | TBD |
| zkSync Era | TBD |

### Axelar Sender Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | TBD |
| Arbitrum One | [0xb162BF709505765605B447F9817acbF428cB86F6](https://arbiscan.io/address/0xb162BF709505765605B447F9817acbF428cB86F6#code) |
| Avalanche | [0x0808CC60D8E6c130c2133e4b3B499ba0D0B1aB88](https://snowtrace.io/address/0x0808CC60D8E6c130c2133e4b3B499ba0D0B1aB88#code) |
| Base | [0xb162BF709505765605B447F9817acbF428cB86F6](https://basescan.org/address/0xb162BF709505765605B447F9817acbF428cB86F6#code) |
| BNB Chain | [0xb162BF709505765605B447F9817acbF428cB86F6](https://bscscan.com/address/0xb162BF709505765605B447F9817acbF428cB86F6#code) |
| Cronos | TBD |
| Fantom | [0x0d6cf9AF5062e20dE91480eF61E44F5C97C124D9](https://ftmscan.com/address/0x0d6cf9AF5062e20dE91480eF61E44F5C97C124D9#code) |
| Kava | [0x027d732749992c7b12D8c48a08eFCcE9Cb1288BC](https://kavascan.com/address/0x027d732749992c7b12D8c48a08eFCcE9Cb1288BC/contracts) |
| Mantle | [0x523073f029C889242beBFbB7eE3BDaB52942a39A](https://explorer.mantle.xyz/address/0x523073f029C889242beBFbB7eE3BDaB52942a39A/contracts) |
| Metis | TBD |
| Neon | TBD |
| Optimism | [0xb162BF709505765605B447F9817acbF428cB86F6](https://optimistic.etherscan.io/address/0xb162BF709505765605B447F9817acbF428cB86F6#code) |
| Polygon | [0xb162BF709505765605B447F9817acbF428cB86F6](https://polygonscan.com/address/0xb162BF709505765605B447F9817acbF428cB86F6#code) |
| Telos | TBD |
| zkSync Era | TBD |

### LayerZero Receiver Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | [0xA104f95135fF89DA3A4fF8Aae88a52eBCB41A1BB](https://nova.arbiscan.io/address/0xA104f95135fF89DA3A4fF8Aae88a52eBCB41A1BB#code) |
| Arbitrum One | [0xfD4Cc2d4ABf0FBd87882004cAB576268e6e32bAE](https://arbiscan.io/address/0xfD4Cc2d4ABf0FBd87882004cAB576268e6e32bAE#code) |
| Avalanche | [0x193A2D15a9A8fA02301116d4f3666619154BEeB7](https://snowtrace.io/address/0x193A2D15a9A8fA02301116d4f3666619154BEeB7#code) |
| Base | [0x4d4178E7b48cB5B6D0b7C6E860824838ffCb22b1](https://basescan.org/address/0x4d4178E7b48cB5B6D0b7C6E860824838ffCb22b1#code) |
| BNB Chain | [0xfD4Cc2d4ABf0FBd87882004cAB576268e6e32bAE](https://bscscan.com/address/0xfD4Cc2d4ABf0FBd87882004cAB576268e6e32bAE#code) |
| Cronos | TBD |
| Fantom | [0x492535a017262d121D254B20398cb716575Cc9B8](https://ftmscan.com/address/0x492535a017262d121D254B20398cb716575Cc9B8#code) |
| Kava | [0xE564E8F21E93088a53fa2164A95DB6fE45309f99](https://kavascan.com/address/0xE564E8F21E93088a53fa2164A95DB6fE45309f99/contracts) |
| Mantle | [0xc23350F2bf5b0e368B93ddC40E815de10a90C0c3](https://explorer.mantle.xyz/address/0xc23350F2bf5b0e368B93ddC40E815de10a90C0c3/contracts) |
| Metis | [0x877fe019d5320bc5A1ab6d72f05D13ba8A651350](https://explorer.metis.io/address/0x877fe019d5320bc5A1ab6d72f05D13ba8A651350/contract/1088/code) |
| Neon | TBD |
| Optimism | [0xE0bB58736b5C373Ecd104068e4Ab57399A3b16D7](https://optimistic.etherscan.io/address/0xE0bB58736b5C373Ecd104068e4Ab57399A3b16D7#code) |
| Polygon | [0x724f9A247A6755d5Fd93e0cf1e563F9441523618](https://polygonscan.com/address/0x724f9A247A6755d5Fd93e0cf1e563F9441523618#code) |
| Telos | [0x52093032E619C1493206CF52c47B41E5b7964bce](https://www.teloscan.io/address/0x52093032E619C1493206CF52c47B41E5b7964bce#contract) |
| zkSync Era | [0x12BEC3a4FD7e8e258e4e42e92FDCe9BE6F28D940](https://explorer.zksync.io/address/0x12BEC3a4FD7e8e258e4e42e92FDCe9BE6F28D940#contract) |

### LayerZero Sender Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | [0x0d6cf9AF5062e20dE91480eF61E44F5C97C124D9](https://nova.arbiscan.io/address/0x0d6cf9AF5062e20dE91480eF61E44F5C97C124D9#code) |
| Arbitrum One | [0x2d45D18bc844CFb242B77cC5943bd318dcAd5407](https://arbiscan.io/address/0x2d45D18bc844CFb242B77cC5943bd318dcAd5407#code) |
| Avalanche | [0xFD7A105225433c05fE0E5851df7AF5C00b245dF8](https://snowtrace.io/address/0xFD7A105225433c05fE0E5851df7AF5C00b245dF8#code) |
| Base | [0x2d45D18bc844CFb242B77cC5943bd318dcAd5407](https://basescan.org/address/0x2d45D18bc844CFb242B77cC5943bd318dcAd5407#code) |
| BNB Chain | [0x2d45D18bc844CFb242B77cC5943bd318dcAd5407](https://bscscan.com/address/0x2d45D18bc844CFb242B77cC5943bd318dcAd5407#code) |
| Cronos | TBD |
| Fantom | [0x639126426445b709e7b67f210604115c277fdFaA](https://ftmscan.com/address/0x639126426445b709e7b67f210604115c277fdFaA#code) |
| Kava | [0x639126426445b709e7b67f210604115c277fdFaA](https://kavascan.com/address/0x639126426445b709e7b67f210604115c277fdFaA/contracts) |
| Mantle | [0xDc2B62D05578A1f3d69c498dF7fF260152bCB6Ee](https://explorer.mantle.xyz/address/0xDc2B62D05578A1f3d69c498dF7fF260152bCB6Ee/contracts) |
| Metis | [0x523073f029C889242beBFbB7eE3BDaB52942a39A](https://explorer.metis.io/address/0x523073f029C889242beBFbB7eE3BDaB52942a39A/contract/1088/code) |
| Neon | TBD |
| Optimism | [0x2d45D18bc844CFb242B77cC5943bd318dcAd5407](https://optimistic.etherscan.io/address/0x2d45D18bc844CFb242B77cC5943bd318dcAd5407#code) |
| Polygon | [0x2d45D18bc844CFb242B77cC5943bd318dcAd5407](https://polygonscan.com/address/0x2d45D18bc844CFb242B77cC5943bd318dcAd5407#code) |
| Telos | [0x0d6cf9AF5062e20dE91480eF61E44F5C97C124D9](https://www.teloscan.io/address/0x0d6cf9AF5062e20dE91480eF61E44F5C97C124D9#contract) |
| zkSync Era | [0x63954018EdC88b17950e70Ade6bB606131265f02](https://explorer.zksync.io/address/0x63954018EdC88b17950e70Ade6bB606131265f02#contract) |

### DEX Weekly Updater Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | TBD |
| Arbitrum One | TBD |
| Avalanche | TBD |
| Base | TBD |
| BNB Chain | TBD |
| Cronos | TBD |
| Fantom | TBD |
| Kava | TBD |
| Mantle | TBD |
| Metis | TBD |
| Neon | TBD |
| Optimism | TBD |
| Polygon | [0xA28cEbC0f64Bb3D1974a3DF9441E2dF8414E376F](https://polygonscan.com/address/0xA28cEbC0f64Bb3D1974a3DF9441E2dF8414E376F#code) |
| Telos | TBD |
| zkSync Era | TBD |

### Chainlink Data Feed Publisher Contract Addresses

| Chain | Address |
| :--- | :--- |
| Arbitrum Nova | TBD |
| Arbitrum One | [0x4d4178E7b48cB5B6D0b7C6E860824838ffCb22b1](https://arbiscan.io/address/0x4d4178E7b48cB5B6D0b7C6E860824838ffCb22b1#code) |
| Avalanche | TBD |
| Base | TBD |
| BNB Chain | TBD |
| Cronos | TBD |
| Fantom | TBD |
| Kava | TBD |
| Mantle | TBD |
| Metis | TBD |
| Neon | TBD |
| Optimism | TBD |
| Polygon | TBD |
| Telos | TBD |
| zkSync Era | TBD |

## Chain IDs

| Chain | ID |
| :--- | :--- |
| Arbitrum Nova | 42170 |
| Arbitrum One | 42161 |
| Avalanche | 43114 |
| Base | 8453 |
| BNB Chain | 56 |
| Cronos | 25 |
| Fantom | 250 |
| Kava | 2222 |
| Mantle | 5000 |
| Metis | 1088 |
| Neon | 245022934 |
| Optimism | 10 |
| Polygon | 137 |
| Telos | 40 |
| zkSync Era | 324 |