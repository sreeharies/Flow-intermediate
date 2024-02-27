import FungibleToken from 0x05
import jio from 0x05

transaction(receiver: Address, amount: UFix64) {

    prepare(signer: AuthAccount) {

        let minter =signer.borrow<&jio.Minter>(from: /storage/MinterStorage)
            ?? panic("You are not the jio minter")


        let receiverVault = getAccount(receiver)
            .getCapability<&jio.Vault{FungibleToken.Receiver}>(/public/Vault)
            .borrow()
            ?? panic("Error: Check your jio Vault status")


        let mintedTokens <- minter.mintToken(amount: amount)


        receiverVault.deposit(from: <-mintedTokens)
    }

    execute {
        log("stackToken minted and deposited successfully")
        log("Tokens minted and deposited: ".concat(amount.toString()))
    }
}
