import { defineConfig } from 'vocs'
import { sidebar } from './sidebar'
export default defineConfig({
  title: 'alloy',
  sidebar,
  sponsors: [
    {
      name: 'Collaborator',
      height: 120,
      items: [
        [
          {
            name: 'Paradigm',
            link: 'https://paradigm.xyz',
            image:
              'https://raw.githubusercontent.com/wevm/.github/main/content/sponsors/paradigm-light.svg',
          },
          {
            name: 'Ithaca',
            link: 'https://ithaca.xyz',
            image:
              'https://raw.githubusercontent.com/wevm/.github/main/content/sponsors/ithaca-light.svg',
          },
        ],
      ],
    }
  ],
  iconUrl: { light: '/favicon.png', dark: '/favicon.png' },
  head() {
    return (
      <>
        <meta name="twitter:card" content="summary"/>
        <meta property="og:title" content="Alloy Docs" />
        <meta property="og:description" content="All things Alloy" />
        <meta property="og:image" content="https://raw.githubusercontent.com/alloy-rs/book/master/src/images/banner.jpg" />
      </>
    )
  },
})
