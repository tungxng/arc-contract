# ARC Market Smart Contracts

Smart contracts for ARC Market platform including GM messaging, ERC20 token creation, and NFT collection deployment.

## Contracts

### 1. GMContract
Simple contract to send GM (Good Morning) messages between addresses.

**Functions:**
- `sendGM(address to, string memory message)` - Send a GM message
- `sendSimpleGM(address to)` - Send a simple GM with default message
- `getGMCount(address user)` - Get total GM count for a user
- `getGMHistory(address user)` - Get all GM messages sent by a user

### 2. ERC20TokenFactory
Factory contract to deploy ERC20 tokens.

**Functions:**
- `createToken(string name, string symbol, uint8 decimals, uint256 initialSupply)` - Deploy a new ERC20 token
- `getAllTokens()` - Get all deployed tokens
- `getUserTokens(address user)` - Get tokens created by a user
- `getTokenCount()` - Get total number of deployed tokens

### 3. NFTFactory
Factory contract to deploy NFT collections.

**Functions:**
- `createNFTCollection(string name, string symbol)` - Deploy a new NFT collection
- `getAllCollections()` - Get all deployed collections
- `getUserCollections(address user)` - Get collections created by a user
- `getCollectionCount()` - Get total number of deployed collections

## Installation

```bash
npm install
```

## Compile

```bash
npm run compile
```

## Test

```bash
npm run test
```

## Deploy

### Local Network (Hardhat)

```bash
npm run node
# In another terminal
npm run deploy
```

### Arc Testnet

1. Create a `.env` file:
```
PRIVATE_KEY=your_private_key_here
```

2. Update `hardhat.config.js` with your network settings

3. Deploy:
```bash
npx hardhat run scripts/deploy.js --network arcTestnet
```

## Contract Addresses

After deployment, save the contract addresses for frontend integration:

- GMContract: `0x...`
- ERC20TokenFactory: `0x...`
- NFTFactory: `0x...`

## Usage Examples

### Send GM
```javascript
const gmContract = await ethers.getContractAt("GMContract", gmAddress);
await gmContract.sendGM(recipientAddress, "GM! 🚀");
```

### Create ERC20 Token
```javascript
const tokenFactory = await ethers.getContractAt("ERC20TokenFactory", tokenFactoryAddress);
await tokenFactory.createToken("My Token", "MTK", 18, 1000000);
```

### Create NFT Collection
```javascript
const nftFactory = await ethers.getContractAt("NFTFactory", nftFactoryAddress);
await nftFactory.createNFTCollection("My NFT", "MNFT");
```

## License

MIT

# arc-contract
