import { Sidebar } from "vocs";

export const sidebar: Sidebar = [
    {
      text: 'Getting Started',
      items: [
        { text: 'Installation', link: '/getting-started/installation' },
        { text: 'Quick Start', link: '/getting-started/quick-start' },
      ]
    },
    {
        text: 'Migrating from ethers-rs',
        items: [
            { text: 'Reference', link: '/migrating-from-ethers/reference' },
            { text: 'Conversions', link: '/migrating-from-ethers/conversions' },
        ]
    },
    {
      text: 'Building with alloy',
      items: [
        { text: 'Basic building blocks', items: [
          { text: 'Hash and Address types', link: '/building-with-alloy/basic-building-blocks/hash-and-address-types' },
          { text: 'Initializing big numbers', link: '/building-with-alloy/basic-building-blocks/big-numbers' },
          { text: 'Using big numbers', link: '/building-with-alloy/basic-building-blocks/using-big-numbers' },
          { text: 'Common conversions', link: '/building-with-alloy/basic-building-blocks/common-conversions' },
          { text: 'Comparisons and equivalence', link: '/building-with-alloy/basic-building-blocks/comparisons-and-equivalence' },
        ]
       },
       {
          text: 'Connecting to a blockchain', items: [
            { text: 'Setting up a provider', link: '/building-with-alloy/connecting-to-a-blockchain/setting-up-a-provider' },
            { text: 'HTTP provider', link: '/building-with-alloy/connecting-to-a-blockchain/http-provider' },
            { text: 'WS provider', link: '/building-with-alloy/connecting-to-a-blockchain/ws-provider' },
            { text: 'IPC provider', link: '/building-with-alloy/connecting-to-a-blockchain/ipc-provider' },
          ]
       },
       {
        text: 'Best Practices', items: [
          { text: 'Wrapping a provider', link: '/building-with-alloy/best-practices/wrapping-a-provider' },
          { text: 'Interacting with multiple networks', link: '/building-with-alloy/best-practices/interacting-with-multiple-networks' },
          { text: 'Signers vs Ethereum Wallet', link: '/building-with-alloy/best-practices/signers-vs-ethereum-wallet' },
          { text: 'Multicall', link: '/building-with-alloy/best-practices/multicall' },
        ]
       },
       {
        text: 'Transactions', items: [
          { text: 'Using the Transaction Builder', link: '/building-with-alloy/transactions/using-the-transaction-builder' },
          { text: 'Sending a Legacy Transaction', link: '/building-with-alloy/transactions/sending-a-legacy-transaction' },
          { text: 'Sending an EIP-1559 Transaction', link: '/building-with-alloy/transactions/sending-an-EIP-1559-transaction' },
          { text: 'Sending an EIP-4844 Transaction', link: '/building-with-alloy/transactions/sending-an-EIP-4844-transaction' },
          { text: 'Sending an EIP-7702 Transaction', link: '/building-with-alloy/transactions/sending-an-EIP-7702-transaction' },
          { text: 'Using Access Lists', link: '/building-with-alloy/transactions/using-access-lists' },
        ]
       },
       { text: 'Understanding Fillers', link: '/building-with-alloy/understanding-fillers' },
       { text: 'Queries', link: '/building-with-alloy/queries' }
      ]
    },
]