import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  tutorialSidebar: [
    {type: 'doc', id: 'intro', label: 'Overview'},
    {type: 'doc', id: 'roadmap', label: 'Roadmap'},
    {
      type: 'category',
      label: 'Contributing',
      collapsed: false,
      items: ['contributing/contributing'],
    },
    {
      type: 'category',
      label: 'Templates',
      collapsed: false,
      items: ['templates/authoring', 'templates/data-pipeline'],
    },
    {
      type: 'category',
      label: 'Developer',
      collapsed: false,
      items: [
        'developer/architecture',
        'developer/directory-structure',
        'developer/design',
        {
          type: 'category',
          label: 'Mobile',
          collapsed: false,
          items: [
            'developer/mobile/development-setup',
            'developer/mobile/obd-integration',
            'developer/mobile/native-car',
          ],
        },
      ],
    },
  ],
};

export default sidebars;