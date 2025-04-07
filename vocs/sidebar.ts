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
    }
  ]