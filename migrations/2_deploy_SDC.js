const SDC = artifacts.require('SDC');


module.exports = (deployer) => {
  deployer.deploy(SDC, 'SDC deployment');
};
