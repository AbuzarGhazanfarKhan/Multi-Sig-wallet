const Wallet = artifacts.require("Wallet")


contract("Wallet", (accounts) => {
    let wallet
    beforeEach(async () => {
        wallet= await Wallet.new([accounts[0],accounts[1],accounts[2]],2)
        await web3.eth.sendTransaction({from:accounts[0],to:wallet.address,value:1000})
    })
    // before it() block execute beforeEach is executed so we can use wallet keyword
    it("should have correct approvers and criteria", async () => {
        const approvers = await wallet.getApprovers()
        const criteria = await wallet.criteria()
        assert(approvers.length === 3)
        assert(approvers[0] ===accounts[0])
        assert(approvers[1] ===accounts[1])
        assert(approvers[2] === accounts[2])
        assert(criteria.toNumber() === 2)
    })
})