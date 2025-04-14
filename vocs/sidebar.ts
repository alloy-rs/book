import { Sidebar } from "vocs";
import { exampleItems } from "./example-items";

export const sidebar: Sidebar = [
    {
      text: 'Introduction',
      items: [
        { text: 'Installation', link: '/introduction/installation' },
        { text: 'Why Alloy', link: '/introduction/why-alloy' },
        { text: 'Getting Started', link: '/introduction/getting-started' },
      ]
    },
    {
      text: 'Guides',
      items: [
        { text: 'Performant Static and Dynamic ABIs Encoding with Alloy', link: '/guides/static-dynamic-abi-in-alloy' },
        { text: 'Build a fast MEV bot with Alloy\'s Primitive Types', link: '/guides/speed-up-using-u256' },
        { text: 'Building a High-Priority Transaction Queue with Alloy Fillers', link: '/guides/fillers' },
        { text: 'Customizing RPC Communication with Alloy\'s Layers', link: '/guides/layers' },
      ]
    },
    { text: 'Using Primitives & Types',
      items: [
      { text: 'Hash and Address types', link: '/using-primitive-types/hash-and-address-types' },
      { text: 'Initializing big numbers', link: '/using-primitive-types/big-numbers' },
      { text: 'Using big numbers', link: '/using-primitive-types/using-big-numbers' },
      { text: 'Common conversions', link: '/using-primitive-types/common-conversions' },
      { text: 'Comparisons and equivalence', link: '/using-primitive-types/comparisons-and-equivalence' },
    ]
   },
    { 
      text: 'RPC Providers', 
      items: [
      { text: 'Setting up a provider', link: '/rpc-providers/setting-up-a-provider' },
      { text: 'HTTP provider', link: '/rpc-providers/http-provider' },
      { text: 'WS provider', link: '/rpc-providers/ws-provider' },
      { text: 'IPC provider', link: '/rpc-providers/ipc-provider' },
      { text: 'Understanding Fillers', link: '/rpc-providers/understanding-fillers'}
    ]
   },
   {
    text: 'Submitting Transactions', 
    items: [
      { text: 'Transaction Lifecycle', link: '/transactions/transaction-lifecycle' },
      { text: 'Using the Transaction Builder', link: '/transactions/using-the-transaction-builder' },
      { text: 'Legacy Transaction', link: '/transactions/sending-a-legacy-transaction' },
      { text: 'EIP-1559 Transaction', link: '/transactions/sending-an-EIP-1559-transaction' },
      { text: 'EIP-4844 Transaction', link: '/transactions/sending-an-EIP-4844-transaction' },
      { text: 'EIP-7702 Transaction', link: '/transactions/sending-an-EIP-7702-transaction' },
      { text: 'Using Access Lists', link: '/transactions/using-access-lists' },
    ]
   },
   {
    text: 'Interacting with smart contracts', 
    items: [
      { text: 'The sol! macro', link: '/interacting-smart-contracts/the-sol!-macro' },
    ]
   },
    {
      text: 'Miscellaneous',
      items: [
       {
        text: 'Best Practices', collapsed: true, items: [
          { text: 'Wrapping a provider', link: '/misc/best-practices/wrapping-a-provider' },
          { text: 'Interacting with multiple networks', link: '/misc/best-practices/interacting-with-multiple-networks' },
          { text: 'Signers vs Ethereum Wallet', link: '/misc/best-practices/signers-vs-ethereum-wallet' },
          { text: 'Multicall', link: '/misc/best-practices/multicall' },
        ]
       },
       { text: 'Querying chain data', link: '/misc/queries' }
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