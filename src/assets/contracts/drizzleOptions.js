import Web3 from "web3";

const options = {
  web3: {
    block: true,
    customProvider: new Web3(window.ethereum),
  },
  contracts: [
  ],
  events: {
  },
  polls: {
    blocks: 3000,
  },
  //syncAlways: true,
};

export default options;