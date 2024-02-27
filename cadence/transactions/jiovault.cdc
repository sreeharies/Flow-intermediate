import FungibleToken from 0x05
import jio from 0x05

transaction() {

    // Define references
    let userVault: &jio.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, jio.CollectionPublic}?
    let account: AuthAccount

    prepare(acct: AuthAccount) {

        // Borrow vault capability and set account reference
        self.userVault = acct.getCapability(/public/Vault)
            .borrow<&jio.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, jio.CollectionPublic}>()

        self.account = acct
    }

    execute {
        if self.userVault == nil {
            // Create and link an empty vault if none exists
            let emptyVault <- jio.createEmptyVault()
            self.account.save(<-emptyVault, to: /storage/VaultStorage)
            self.account.link<&jio.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, jio.CollectionPublic}>(/public/Vault, target: /storage/VaultStorage)
            log("Empty vault created and linked")
        } else {
            log("Vault already exists and is properly linked")
        }
    }
}
