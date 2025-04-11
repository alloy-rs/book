import { Sidebar } from "vocs";
import { exampleItems } from "./example-items";

export const sidebar: Sidebar = [
    {
      text: 'Getting Started',
      items: [
        { text: 'Installation', link: '/getting-started/installation' },
        { text: 'Quick Start', link: '/getting-started/quick-start' },
      ]
    },
    {
      text: 'Building with alloy',
      items: [
        { text: 'Basic building blocks', collapsed: true, items: [
          { text: 'Hash and Address types', link: '/building-with-alloy/basic-building-blocks/hash-and-address-types' },
          { text: 'Initializing big numbers', link: '/building-with-alloy/basic-building-blocks/big-numbers' },
          { text: 'Using big numbers', link: '/building-with-alloy/basic-building-blocks/using-big-numbers' },
          { text: 'Common conversions', link: '/building-with-alloy/basic-building-blocks/common-conversions' },
          { text: 'Comparisons and equivalence', link: '/building-with-alloy/basic-building-blocks/comparisons-and-equivalence' },
        ]
       },
       {
          text: 'Connecting to a blockchain', collapsed: true, items: [
            { text: 'Setting up a provider', link: '/building-with-alloy/connecting-to-a-blockchain/setting-up-a-provider' },
            { text: 'HTTP provider', link: '/building-with-alloy/connecting-to-a-blockchain/http-provider' },
            { text: 'WS provider', link: '/building-with-alloy/connecting-to-a-blockchain/ws-provider' },
            { text: 'IPC provider', link: '/building-with-alloy/connecting-to-a-blockchain/ipc-provider' },
          ]
       },
       {
        text: 'Best Practices', collapsed: true, items: [
          { text: 'Wrapping a provider', link: '/building-with-alloy/best-practices/wrapping-a-provider' },
          { text: 'Interacting with multiple networks', link: '/building-with-alloy/best-practices/interacting-with-multiple-networks' },
          { text: 'Signers vs Ethereum Wallet', link: '/building-with-alloy/best-practices/signers-vs-ethereum-wallet' },
          { text: 'Multicall', link: '/building-with-alloy/best-practices/multicall' },
        ]
       },
       {
        text: 'Sending Transactions', collapsed: true, items: [
          { text: 'Using the Transaction Builder', link: '/building-with-alloy/transactions/using-the-transaction-builder' },
          { text: 'Legacy Transaction', link: '/building-with-alloy/transactions/sending-a-legacy-transaction' },
          { text: 'EIP-1559 Transaction', link: '/building-with-alloy/transactions/sending-an-EIP-1559-transaction' },
          { text: 'EIP-4844 Transaction', link: '/building-with-alloy/transactions/sending-an-EIP-4844-transaction' },
          { text: 'EIP-7702 Transaction', link: '/building-with-alloy/transactions/sending-an-EIP-7702-transaction' },
          { text: 'Using Access Lists', link: '/building-with-alloy/transactions/using-access-lists' },
        ]
       },
       { text: 'The sol! macro', link: '/building-with-alloy/the-sol!-macro' },
       { text: 'Understanding Fillers', link: '/building-with-alloy/understanding-fillers' },
       { text: 'Transaction Lifecycle', link: '/building-with-alloy/transaction-lifecycle' },
       { text: 'Querying chain data', link: '/building-with-alloy/queries' }
      ],
    },
    {
      text: 'Examples',
      items: exampleItems,
    },
    {
      text: 'Migrating to 1.0',
      collapsed: false,
      items: [
          {
              text: 'sol! macro changes',
              collapsed: true,
              items: [
                { text: 'Removing T generic', link: '/migrating-to-core-1.0/sol!-changes/removing-T-generic' },
                { text: 'Improving function return types', link: '/migrating-to-core-1.0/sol!-changes/improving-function-return-types' },
                  { text: 'Function call bindings', link: '/migrating-to-core-1.0/sol!-changes/changes-to-function-call-bindings' },
                  { text: 'Event bindings', link: '/migrating-to-core-1.0/sol!-changes/changes-to-event-bindings' },
                  { text: 'Error bindings', link: '/migrating-to-core-1.0/sol!-changes/changes-to-error-bindings' },
              ]
          },
          {
              text: 'ABI encoding and decoding',
              collapsed: true,
              items: [
                  { text: 'Encoding return structs', link: '/migrating-to-core-1.0/encoding-decoding-changes/encoding-return-structs' },
                  { text: 'Removing validate arg', link: '/migrating-to-core-1.0/encoding-decoding-changes/removing-validate-bool' },
              ]
          },
          { text: 'Other breaking changes', link: '/migrating-to-core-1.0/other-breaking-changes' },
      ]
    },  
    {
      text: 'Migrating from ethers-rs',
      items: [
          { text: 'Reference', link: '/migrating-from-ethers/reference' },
          { text: 'Conversions', link: '/migrating-from-ethers/conversions' },
      ]
    },
]