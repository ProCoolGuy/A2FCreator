const { expect } = require('chai')
const { ethers } = require('hardhat')

let owner, addr1, addr2, addr3
let Token
let token

let provider = ethers.getDefaultProvider()

beforeEach(async function() {
  ;[owner, addr1, addr2, addr3] = await ethers.getSigners()
  Token = await ethers.getContractFactory('BrainDanceNft')

  const baseUri = process.env.BASE_URI
  console.log('baseUri: ', baseUri)
  token = await Token.deploy('BrainDanceNFT', 'BrainDance', baseUri)
  await token.addWhiteLists([owner.address])
})

describe('Token contract', function() {
  it('BrainDanceNft token test', async function() {
    // owner test
    // expect(await token.owner()).to.equal(owner.address)

    // white list test
    // expect(await token.isWhiteList('0x396823F49AA9f0e3FAC4b939Bc27aD5cD88264Db')).to.equal(true)
    // expect(await token.isWhiteList('0x892E10CB1299C16e469cf0f79f18CCa639D00F5B')).to.equal(true)
    // expect(await token.isWhiteList('0xA5DBC34d69B745d5ee9494E6960a811613B9ae32')).to.equal(true)

    // console.log(
    //   'Contract balance: ',
    //   ethers.utils.formatEther(await provider.getBalance(token.address))
    // )

    // // mint
    // await expect(
    //   owner.sendTransaction({
    //     to: token.address,
    //     value: ethers.utils.parseEther('0.07'),
    //     data: token.mint('uri1'),
    //   })
    // ).to.be.reverted

    // for (let i = 0; i < 10; i += 1) {
    //   await token.mint('uri1', {
    //     value: ethers.utils.parseEther('7'),
    //   })
    // }

    // // pause test
    // await token.setPause(true)
    // await expect(
    //   owner.sendTransaction({
    //     to: token.address,
    //     value: ethers.utils.parseEther('0.07'),
    //     data: token.mint('uri1'),
    //   })
    // ).to.be.reverted

    // await token.setPause(false)
    // await token.mint('uri1', {
    //   value: ethers.utils.parseEther('0.07'),
    // })

    // console.log(
    //   'Contract balance: ',
    //   ethers.utils.formatEther(await provider.getBalance(token.address))
    // )
  })
})
