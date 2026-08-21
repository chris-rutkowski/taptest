import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'TapTest',
  tagline: 'User-facing Flutter tests with snapshots',
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

  url: 'https://taptest.dev',
  baseUrl: '/',

  organizationName: 'chris-rutkowski',
  projectName: 'taptest',

  onBrokenLinks: 'throw',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          editUrl: 'https://github.com/chris-rutkowski/taptest/tree/main/docs/',
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: 'img/docusaurus-social-card.jpg',
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'TapTest',
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'docsSidebar',
          position: 'left',
          label: 'Docs',
        },
        {
          href: 'https://pub.dev/packages/taptest',
          label: 'pub.dev',
          position: 'right',
        },
        {
          href: 'https://github.com/chris-rutkowski/taptest',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {label: 'Getting started', to: '/docs/intro'},
            {label: 'Actions', to: '/docs/actions'},
          ],
        },
        {
          title: 'Packages',
          items: [
            {label: 'taptest', href: 'https://pub.dev/packages/taptest'},
            {label: 'taptest_runtime', href: 'https://pub.dev/packages/taptest_runtime'},
          ],
        },
        {
          title: 'More',
          items: [
            {label: 'GitHub', href: 'https://github.com/chris-rutkowski/taptest'},
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Chris Rutkowski`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
