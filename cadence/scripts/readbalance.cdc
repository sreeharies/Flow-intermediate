import FungibleToken from 0x05
import jio from 0x05

pub fun main(account: Address) {

    let publicVault: &jio.Vault{FungibleToken.Balance, FungibleToken.Receiver, jio.CollectionPublic}? =
        getAccount(account).getCapability(/public/Vault)
            .borrow<&jio.Vault{FungibleToken.Balance, FungibleToken.Receiver, jio.CollectionPublic}>()

    if (publicVault == nil) {

        let newVault <- jio.createEmptyVault()
        getAuthAccount(account).save(<-newVault, to: /storage/VaultStorage)
        getAuthAccount(account).link<&jio.Vault{FungibleToken.Balance, FungibleToken.Receiver, jio.CollectionPublic}>(
            /public/Vault,
            target: /storage/VaultStorage
        )
        log("Empty vault created")
        

        let retrievedVault: &jio.Vault{FungibleToken.Balance}? =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&jio.Vault{FungibleToken.Balance}>()
        log(retrievedVault?.balance)
    } else {
        log("Vault already exists and is properly linked")
        
        let checkVault: &jio.Vault{FungibleToken.Balance, FungibleToken.Receiver, jio.CollectionPublic} =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&jio.Vault{FungibleToken.Balance, FungibleToken.Receiver, jio.CollectionPublic}>()
                ?? panic("Vault capability not found")
        

        if jio.vaults.contains(checkVault.uuid) {
            log(publicVault?.balance)
            log("This is a jioToken vault")
        } else {
            log("This is not a jioToken vault")
        }
    }
}
