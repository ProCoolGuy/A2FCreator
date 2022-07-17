const hre = require('hardhat')
const fs = require('fs-extra')

module.exports = async ({getNamedAccounts, deployments}) => {
  const {deploy} = deployments;
  const { account0 } = await getNamedAccounts();

  console.log('Deploying contracts with the account:', account0)

  console.log('------')
  console.log('network name: ', hre.network.name)
  console.log('Deployer: ' + account0)
  console.log('------')

  const baseUri = process.env.BASE_URI
  const token = await deploy('A2FCreators', {
    from: account0,
    args: ["A2FCreator", "A2FC", 5, 20, 100],
    log: true,
  });

  fs.mkdirSync('./export/contracts', {recursive: true})

  const deployData = {
    contractAddress: token.address,
    deployer: account0
  }
  fs.writeFileSync('./export/contracts/config.json', JSON.stringify(deployData, null, 2))

  const contractJson = require('../artifacts/contracts/A2FCreators.sol/A2FCreators.json')
  fs.writeFileSync('./export/contracts/A2FCreators.json', JSON.stringify(contractJson.abi, null, 2))

  console.log('deployData:', deployData)
}

module.exports.tags = ['A2FCreators'];
