const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {

      backgroundImage: {

        'background-image': "url('background1.jpeg')",
        'default_avatar': "url('default_avatar.png')",
        'default_image': "url('image_icon.png')",
        'camera_icon': "url('camera.png')",

      },
      colors: {
        "gold": "#d97706",
        "gold_shade2": "#b45309",
      },

      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/container-queries'),
  ]
}