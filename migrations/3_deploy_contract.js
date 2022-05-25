const DrivingLicense = artifacts.require("DrivingLicense");

module.exports = function (deployer) {
  deployer.deploy(DrivingLicense);
};
