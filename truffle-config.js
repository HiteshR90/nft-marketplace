module.exports = {
  

  networks: {
    development:{
      host:"HTTP://127.0.0.1",
      port:8545,
      network_id:"*"
    }
  },
  contract_directory: "./src/contracts",
  contract_build_directory: "./src/abis",

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.16",  
      optimizer:{
        enabled:'true',
        runs:200
      },    
    }
  },
};
