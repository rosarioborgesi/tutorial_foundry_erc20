## Tutorial: ERC20 with Foundry (Build, Test, Deploy, Interact)

This repository accompanies a [YouTube tutorial](https://www.youtube.com/watch?v=uzUM-aYv9sI) showing how to use Foundry to develop, test, deploy, and interact with a simple ERC20 token. The token is `DiamondToken (DMT)`, based on OpenZeppelin, with owner-only minting and burn support.

### What you’ll learn
- **Build** a Solidity project with Foundry
- **Test** contracts with Forge and cheatcodes
- **Run** a local chain with Anvil
- **Deploy** to local and test networks
- **Interact** with the deployed contract via scripts

### Prerequisites
- Foundry installed (see Foundry Book: `https://book.getfoundry.sh/getting-started/installation`)
- Git + Make (optional but used in commands)
- RPC URLs and keys for testnets if deploying (Sepolia/Base Sepolia)

---

## Quickstart

```shell
git clone <this-repo>
cd tutorial_erc20_foundry
make install      # installs dependencies (forge-std, OZ, foundry-devops)
make build        # or: forge build
make test         # or: forge test
```

Project structure:
- `src/DiamondToken.sol`: ERC20, ERC20Burnable, Ownable; mints initial supply to owner
- `test/DiamondTokenTest.t.sol`: unit tests covering metadata, transfer, approvals, burn, mint auth
- `script/DeployDiamondToken.s.sol`: deployment script
- `script/Interactions.s.sol`: mint interaction against latest deployment
- `script/HelperConfig.s.sol`: resolves `owner` by chain id
- `foundry.toml`: config and remappings
- `Makefile`: handy targets for local and testnet flows

---

## Environment setup

Create a `.env` if deploying/verification on public networks:

```ini
# .env
SEPOLIA_RPC_URL=...
BASE_SEPOLIA_RPC_URL=...
ETHERSCAN_API_KEY=...

# Optional: Foundry account profile if you use keystores
# See: https://book.getfoundry.sh/forge/wallets
```

The Makefile reads `.env` automatically. For local Anvil, a default private key is already included in the Makefile for demos.

Owner address resolution (`script/HelperConfig.s.sol`):
- Chain id `31337` (Anvil): owner is the default Anvil account[0]
- Any other chain: a preset address (`0x01BF...e3df`) used for demonstrations

Initial supply: `10,000 DMT` minted to the owner on deployment.

---

## Build

```shell
make build
# or
forge build
```

---

## Test

```shell
make test
# or
forge test

# Run a single test or file
forge test -m testMint
forge test --match-path test/DiamondTokenTest.t.sol
```

Key scenarios covered:
- Token metadata (name/symbol/decimals)
- Initial supply and owner balance
- Owner-only minting (reverts for non-owners)
- Transfers, approvals, transferFrom
- Burn and burnFrom with event checks

---

## Run a local chain (Anvil)

```shell
make anvil
# or
anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1
```

This starts Anvil with a deterministic mnemonic and fast blocks — perfect for live demos.

---

## Deploy

### Local (Anvil)
In a second terminal (with Anvil running):

```shell
make deploy-anvil
```

This runs `script/DeployDiamondToken.s.sol:DeployDiamondToken` broadcasting from the default Anvil key.

### Sepolia

```shell
make deploy-sepolia
```

Requires `SEPOLIA_RPC_URL` and `ETHERSCAN_API_KEY` in `.env`. Uses your Foundry `--account default` keystore if configured. Includes `--verify` for Etherscan verification.

### Base Sepolia

```shell
make deploy-base-sepolia
```

Requires `BASE_SEPOLIA_RPC_URL` and `ETHERSCAN_API_KEY` in `.env`.

---

## Interact (Mint)

After deploying, you can mint additional tokens to the configured owner using the interaction script. It automatically finds the most recent deployment for the current chain via `foundry-devops`.

### Local (Anvil)
```shell
make mint-anvil
```

### Sepolia
```shell
make mint-sepolia
```

### Base Sepolia
```shell
make mint-base-sepolia
```

The interaction script calls:
```solidity
DiamondToken(diamondToken).mint(owner, 1000 ether);
```
So `1000 * 10^18` units (1000 DMT) are minted to `owner`.

---

## Makefile cheatsheet

```shell
make install           # forge install dependencies (OZ, forge-std, foundry-devops)
make update            # forge update submodules
make build             # forge build
make test              # forge test
make format            # forge fmt
make snapshot          # gas snapshots
make anvil             # start local chain

make deploy-anvil      # deploy locally using Anvil default key
make deploy-sepolia    # deploy to Sepolia (+verify) using .env and keystore
make deploy-base-sepolia

make mint-anvil        # run interaction script (mint) on Anvil
make mint-sepolia      # run interaction script (mint) on Sepolia
make mint-base-sepolia
```

---

## Troubleshooting

- If `lib/` is missing or outdated, run:
  ```shell
  make install
  make update
  ```
- If verification fails, confirm `ETHERSCAN_API_KEY` and that the network’s Etherscan supports the chain. Re-run with `-vvvv` for logs.
- If `DevOpsTools.get_most_recent_deployment` fails, ensure at least one successful `--broadcast` run exists under `broadcast/` for the chain id you’re using.
- If accounts/keys aren’t picked up on testnets, configure a Foundry keystore or pass `--private-key` explicitly (not recommended for production).

---

## Learn more
- Foundry Book: `https://book.getfoundry.sh/`
- OpenZeppelin Contracts: `https://docs.openzeppelin.com/contracts/`
