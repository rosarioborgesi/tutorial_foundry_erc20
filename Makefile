-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil install deploy deploy-sepolia verify

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

all: clean remove install update build

clean  :; forge clean

remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops && forge install foundry-rs/forge-std && forge install openzeppelin/openzeppelin-contracts

update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

deploy-anvil:
	@forge script script/DeployDiamondToken.s.sol:DeployDiamondToken \
		--rpc-url http://localhost:8545 \
		--private-key $(DEFAULT_ANVIL_KEY) \
		--broadcast

deploy-sepolia:
	@forge script script/DeployDiamondToken.s.sol:DeployDiamondToken \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--account default --broadcast \
		--verify --etherscan-api-key $(ETHERSCAN_API_KEY)

deploy-base-sepolia:
	@forge script script/DeployDiamondToken.s.sol:DeployDiamondToken \
		--rpc-url $(BASE_SEPOLIA_RPC_URL) \
		--account default --broadcast \
		--verify --etherscan-api-key $(ETHERSCAN_API_KEY)

mint-anvil:
	@forge script script/Interactions.s.sol:MintDiamondToken \
		--rpc-url http://localhost:8545 \
		--private-key $(DEFAULT_ANVIL_KEY) \
		--broadcast

mint-sepolia:
	@forge script script/Interactions.s.sol:MintDiamondToken \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--account default --broadcast

mint-base-sepolia:
	@forge script script/Interactions.s.sol:MintDiamondToken \
		--rpc-url $(BASE_SEPOLIA_RPC_URL) \
		--account default --broadcast
		



