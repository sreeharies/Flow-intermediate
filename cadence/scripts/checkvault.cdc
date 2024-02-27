import FungibleToken from 0x05
import jio from 0x05

pub fun main(account: Address) {

    let publicVault = getAccount(account)
        .getCapability(/public/Vault)
        .borrow<&jio.Vault{FungibleToken.Balance}>()
        ?? panic("Vault not found, setup might be incomplete")

    log("Vault setup verified successfully")
}
