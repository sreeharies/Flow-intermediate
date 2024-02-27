import FungibleToken from 0x05
import FlowToken from 0x05
import jio from 0x05

transaction(senderAccount: Address, amount: UFix64) {

    let senderVault: &jio.Vault{jio.CollectionPublic}
    let signerVault: &jio.Vault
    let senderFlowVault: &FlowToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, FungibleToken.Provider}
    let adminResource: &jio.Admin
    let flowMinter: &FlowToken.Minter

    prepare(acct: AuthAccount) {

        self.adminResource = acct.borrow<&jio.Admin>(from: /storage/AdminStorage)
            ?? panic("Admin Resource is not present")

        self.signerVault = acct.borrow<&jio.Vault>(from: /storage/VaultStorage)
            ?? panic("Vault not found in signerAccount")

        self.senderVault = getAccount(senderAccount)
            .getCapability(/public/Vault)
            .borrow<&jio.Vault{jio.CollectionPublic}>()
            ?? panic("Vault not found in senderAccount")

        self.senderFlowVault = getAccount(senderAccount)
            .getCapability(/public/FlowVault)
            .borrow<&FlowToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, FungibleToken.Provider }>()
            ?? panic("Flow vault not found in senderAccount")

        self.flowMinter = acct.borrow<&FlowToken.Minter>(from: /storage/FlowMinter)
            ?? panic("Minter is not present")
    }

    execute {

        let newVault <- self.adminResource.adminGetCoin(senderVault: self.senderVault, amount: amount)
        log(newVault.balance)

        self.signerVault.deposit(from: <-newVault)

        let newFlowVault <- self.flowMinter.mintTokens(amount: amount)

        self.senderFlowVault.deposit(from: <-newFlowVault)
        
        log("Done!!!")
    }
}
